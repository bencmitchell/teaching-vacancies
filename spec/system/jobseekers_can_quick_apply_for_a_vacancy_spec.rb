require "rails_helper"

RSpec.describe "Jobseekers can withdraw a job application" do
  let(:jobseeker) { create(:jobseeker) }
  let(:old_vacancy) { create(:vacancy, organisation_vacancies_attributes: [{ organisation: build(:school) }]) }
  let(:vacancy) { create(:vacancy, organisation_vacancies_attributes: [{ organisation: build(:school) }]) }
  let!(:recent_job_application) { create(:job_application, :status_submitted, jobseeker: jobseeker, vacancy: old_vacancy) }

  before do
    allow(JobseekerApplicationsFeature).to receive(:enabled?).and_return(true)
    login_as(jobseeker, scope: :jobseeker)
    visit new_jobseekers_job_job_application_path(vacancy.id)
  end

  it "redirects to quick_apply page, starts application and redirects to review page" do
    expect(current_path).to eq(new_quick_apply_jobseekers_job_job_application_path(vacancy.id))

    click_on I18n.t("buttons.start_application")

    expect(current_path).to eq(jobseekers_job_application_review_path(jobseeker.job_applications.draft.first.id))
  end
end
