class Jobseekers::JobApplication::Details::ReferenceForm
  include ActiveModel::Model

  attr_accessor :name, :job_title, :organisation, :relationship, :email, :phone_number

  validates :name, :job_title, :organisation, :relationship, :email, :phone_number, presence: true
  validates :email, format: { with: Devise.email_regexp }
  validates :phone_number, format: { with: /\A\+?(?:\d\s?){10,12}\z/.freeze }
end
