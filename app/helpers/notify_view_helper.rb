module NotifyViewHelper
  def notify_mail_to(mail_to, text = mail_to)
    notify_link("mailto:#{mail_to}", text)
  end

  def notify_link(url, text = url)
    "[#{text}](#{url})"
  end

  def awaiting_feedback_jobs_link
    url = jobs_with_type_organisation_url(type: "awaiting_feedback", **utm_params)
    notify_link(url, "here")
  end

  def choose_organisation_link(token)
    url = login_key_url(token, **utm_params)
    notify_link(url)
  end

  def edit_subscription_link(subscription)
    url = edit_subscription_url(subscription.token, **utm_params)
    notify_link(url, t(".edit_link_text"))
  end

  def email_confirmation_link(token, confirmation_type)
    url = jobseeker_confirmation_url(confirmation_token: token, **utm_params)
    notify_link(url, t("#{confirmation_type}.link"))
  end

  def home_page_link(text = t("app.title"))
    url = root_url(**utm_params)
    notify_link(url, text)
  end

  def job_alert_feedback_url(relevant, subscription, vacancies)
    params = { job_alert_feedback: { relevant_to_user: relevant,
                                     job_alert_vacancy_ids: vacancies.pluck(:id),
                                     search_criteria: subscription.search_criteria } }.merge(utm_params)
    new_subscription_job_alert_feedback_url(subscription.token, **params)
  end

  def jobseeker_job_applications_link
    url = jobseekers_job_applications_url(**utm_params)
    notify_link(url, t(".next_steps.link_text"))
  end

  def publisher_job_applications_link(vacancy)
    url = organisation_job_job_applications_url(vacancy, **utm_params)
    notify_link(url, t(".view_applications", count: vacancy.job_applications.submitted_yesterday.count))
  end

  def publisher_sign_in_link
    url = new_publisher_session_url(**utm_params)
    notify_link(url, "sign into your Teaching Vacancies account")
  end

  def reset_password_link(token)
    url = edit_jobseeker_password_url(reset_password_token: token, **utm_params)
    notify_link(url, t(".link"))
  end

  def show_link(vacancy)
    url = vacancy.share_url(**utm_params)
    notify_link(url, vacancy.job_title)
  end

  def sign_up_link
    url = new_jobseeker_registration_url(**utm_params)
    notify_link(url, t(".create_account.link"))
  end

  def unlock_account_link(token)
    url = jobseeker_unlock_url(unlock_token: token, **utm_params)
    notify_link(url, t(".link"))
  end

  def unsubscribe_link(subscription)
    url = unsubscribe_subscription_url(subscription.token, **utm_params)
    notify_link(url, t(".unsubscribe_link_text"))
  end

  private

  def utm_params
    { utm_source: uid, utm_medium: "email", utm_campaign: utm_campaign }
  end
end
