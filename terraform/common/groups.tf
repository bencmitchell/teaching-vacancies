resource aws_iam_group administrators {
  name = "Administrators"
  path = "/${local.service_name}/"
}

resource aws_iam_group billingmanagers {
  name = "BillingManagers"
  path = "/${local.service_name}/"
}

resource aws_iam_group developers {
  name = "Developers"
  path = "/${local.service_name}/"
}

data aws_iam_policy_document assume_role_if_mfa_present {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}
resource aws_iam_role administrator {
  name               = "Administrator"
  assume_role_policy = data.aws_iam_policy_document.assume_role_if_mfa_present.json
}

data aws_iam_policy_document allow_assume_role_administrator {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.administrator.name}"]
  }
}

resource aws_iam_policy allow_assume_role_administrator {
  name        = "allow_assume_role_administrator"
  description = "Allow assuming administrator role"
  policy      = data.aws_iam_policy_document.allow_assume_role_administrator.json
}

resource aws_iam_role_policy_attachment administrator_role_policies {
  for_each = toset([
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ])

  role       = aws_iam_role.administrator.name
  policy_arn = each.value
}
resource aws_iam_role billingmanager {
  name               = "BillingManager"
  assume_role_policy = data.aws_iam_policy_document.assume_role_if_mfa_present.json
}

data aws_iam_policy_document allow_assume_role_billingmanager {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.billingmanager.name}"]
  }
}

resource aws_iam_policy allow_assume_role_billingmanager {
  name        = "allow_assume_role_billingmanager"
  description = "Allow assuming billingmanager role"
  policy      = data.aws_iam_policy_document.allow_assume_role_billingmanager.json
}

resource aws_iam_role_policy_attachment billingmanager_role_policies {
  for_each = toset([
    "arn:aws:iam::aws:policy/job-function/Billing",
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ])

  role       = aws_iam_role.billingmanager.name
  policy_arn = each.value
}
resource aws_iam_role readonly {
  name               = "ReadOnly"
  assume_role_policy = data.aws_iam_policy_document.assume_role_if_mfa_present.json
}

data aws_iam_policy_document allow_assume_role_readonly {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.readonly.name}"]
  }
}

resource aws_iam_policy allow_assume_role_readonly {
  name        = "allow_assume_role_readonly"
  description = "Allow assuming readonly role"
  policy      = data.aws_iam_policy_document.allow_assume_role_readonly.json
}

resource aws_iam_role_policy_attachment readonly_role_policies {
  role       = aws_iam_role.readonly.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource aws_iam_role secreteditor {
  name               = "SecretEditor"
  assume_role_policy = data.aws_iam_policy_document.assume_role_if_mfa_present.json
}

data aws_iam_policy_document allow_assume_role_secreteditor {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.secreteditor.name}"]
  }
}

resource aws_iam_policy allow_assume_role_secreteditor {
  name        = "allow_assume_role_secreteditor"
  description = "Allow assuming secreteditor role"
  policy      = data.aws_iam_policy_document.allow_assume_role_secreteditor.json
}

data aws_iam_policy_document parameter_store {
  statement {
    actions = [
      "ssm:DescribeParameters",
      "ssm:PutParameter",
      "ssm:GetParameterHistory",
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]
    resources = [
      "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/${local.service_name}/*"
    ]
  }
}

resource aws_iam_policy parameter_store {
  name   = "parameter_store"
  policy = data.aws_iam_policy_document.parameter_store.json
}


resource aws_iam_role_policy_attachment secreteditor_role_policies {
  role       = aws_iam_role.secreteditor.name
  policy_arn = aws_iam_policy.parameter_store.arn
}

# Allow groups to assume roles

resource aws_iam_group_policy_attachment permit_administrators_group_assume_role_administrator {
  group      = aws_iam_group.administrators.name
  policy_arn = aws_iam_policy.allow_assume_role_administrator.arn
}
resource aws_iam_group_policy_attachment permit_billingmanagers_group_assume_role_billingmanager {
  group      = aws_iam_group.billingmanagers.name
  policy_arn = aws_iam_policy.allow_assume_role_billingmanager.arn
}
resource aws_iam_group_policy_attachment permit_developers_group_assume_role_readonly {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.allow_assume_role_readonly.arn
}

resource aws_iam_group_policy_attachment permit_developers_group_assume_role_secreteditor {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.allow_assume_role_secreteditor.arn
}