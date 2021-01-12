require "rails_helper"

RSpec.describe "Hiring staff can see vacancy statistics" do
  let(:school) { create(:school) }
  let(:total_pageviews) { nil }
  let(:total_get_more_info_clicks) { nil }

  before { stub_publishers_auth(urn: school.urn) }

  context "when vacancy is published" do
    let(:status) { "published" }

    let!(:vacancy) do
      create(:vacancy,
             status: status,
             total_pageviews: total_pageviews,
             total_get_more_info_clicks: total_get_more_info_clicks)
    end

    before do
      vacancy.organisation_vacancies.create(organisation: school)
      visit organisation_path(school)
    end

    context "page views are nil" do
      scenario "page views show zero" do
        within(".card#vacancy_#{vacancy.id}") do
          expect(page.find(".card__details")).to have_content("0")
        end
      end
    end

    context "page views are present" do
      let(:total_pageviews) { 100 }

      scenario "page views show the page view count" do
        within(".card#vacancy_#{vacancy.id}") do
          expect(page.find(".card__details")).to have_content(total_pageviews)
        end
      end
    end
  end
end
