class Jobseekers::JobApplications::BuildController < Jobseekers::ApplicationController
  include Wicked::Wizard
  include Jobseekers::Wizardable

  steps :personal_details, :professional_status, :personal_statement, :ask_for_support, :declarations

  helper_method :back_link_path, :job_application, :process_steps

  def process_steps
    ProcessSteps.new(steps: steps_config, adjust: 0, step: step)
  end

  def show
    @form = FORMS[step].new unless step == "wicked_finish"
    render_wizard
  end

  def update
    @form = FORMS[step].new(form_params)
    application_data = job_application.application_data.presence || {}

    if params[:commit] == t("buttons.save_as_draft")
      job_application.assign_attributes(application_data: application_data.merge(form_params))
      job_application.save
      redirect_to jobseekers_saved_jobs_path, success: t(".saved_job_application")
    elsif @form.valid?
      job_application.assign_attributes(application_data: application_data.merge(form_params))
      render_wizard job_application
    else
      render_wizard
    end
  end

  private

  def back_link_path
    @back_link_path ||= case step
                        when :personal_details
                          new_jobseekers_job_application_path(job_application.vacancy.id)
                        else
                          previous_wizard_path
                        end
  end

  def form_params
    send(FORM_PARAMS[step], params)
  end

  def finish_wizard_path
    jobseekers_job_application_review_path(job_application)
  end

  def job_application
    @job_application ||= current_jobseeker.job_applications.find(params[:job_application_id])
  end
end
