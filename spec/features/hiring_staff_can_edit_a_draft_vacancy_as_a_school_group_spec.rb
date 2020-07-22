require 'rails_helper'

RSpec.feature 'Editing a draft vacancy' do
  let(:school_group) { create(:school_group) }
  let(:school_1) { create(:school, name: 'First school') }
  let(:school_2) { create(:school, name: 'Second school') }
  let(:session_id) { SecureRandom.uuid }
  let(:vacancy) { create(:vacancy, :with_school_group, :draft, school_group: school_group) }

  before do
    allow(SchoolGroupJobsFeature).to receive(:enabled?).and_return(true)
    SchoolGroupMembership.find_or_create_by(school_id: school_1.id, school_group_id: school_group.id)
    SchoolGroupMembership.find_or_create_by(school_id: school_2.id, school_group_id: school_group.id)
    stub_hiring_staff_auth(uid: school_group.uid, session_id: session_id)
  end

  describe '#job_location' do
    scenario 'can edit job location' do
      visit organisation_job_review_path(vacancy.id)

      expect(page).to have_content(school_group_location_heading(vacancy.job_location))
      expect(page).to have_content(location(school_group))

      click_header_link(I18n.t('jobs.job_location'))
      vacancy.job_location = 'at_one_school'
      fill_in_job_location_form_field(vacancy)
      click_on I18n.t('buttons.update_job')

      expect(page.current_path).to eql(organisation_job_school_path(vacancy.id))
      fill_in_school_form_field(school_1)
      click_on I18n.t('buttons.update_job')

      expect(page.current_path).to eql(organisation_job_review_path(vacancy.id))
      expect(page).to have_content(school_group_location_heading(vacancy.job_location))
      expect(page).to have_content(location(school_1))

      click_header_link(I18n.t('jobs.job_location'))
      vacancy.job_location = 'at_one_school'
      fill_in_job_location_form_field(vacancy)
      click_on I18n.t('buttons.update_job')

      expect(page.current_path).to eql(organisation_job_school_path(vacancy.id))
      fill_in_school_form_field(school_2)
      click_on I18n.t('buttons.update_job')

      expect(page.current_path).to eql(organisation_job_review_path(vacancy.id))
      expect(page).to have_content(school_group_location_heading(vacancy.job_location))
      expect(page).to have_content(location(school_2))

      click_header_link(I18n.t('jobs.job_location'))
      vacancy.job_location = 'central_office'
      fill_in_job_location_form_field(vacancy)
      click_on I18n.t('buttons.update_job')

      expect(page.current_path).to eql(organisation_job_review_path(vacancy.id))
      expect(page).to have_content(school_group_location_heading(vacancy.job_location))
      expect(page).to have_content(location(school_group))
    end
  end
end
