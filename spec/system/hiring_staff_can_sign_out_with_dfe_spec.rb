require "rails_helper"
RSpec.describe "Hiring staff can sign out with DfE Sign In" do
  let(:school) { create(:school) }

  before { allow(AuthenticationFallback).to receive(:enabled?).and_return(false) }

  scenario "as an authenticated user" do
    stub_publishers_auth(urn: school.urn)

    visit root_path

    click_on(I18n.t("nav.sign_out"))

    sign_out_via_dsi

    within(".govuk-header__navigation") { expect(page).to have_content(I18n.t("nav.for_schools")) }
    expect(page).to have_content(I18n.t("messages.access.publisher_signed_out"))
  end
end
