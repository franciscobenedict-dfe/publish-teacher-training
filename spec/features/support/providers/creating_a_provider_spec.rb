# frozen_string_literal: true

require "rails_helper"

feature "Creating a provider" do
  let(:user) { create(:user, :admin) }

  before do
    given_i_am_authenticated(user:)
    when_i_visit_the_new_provider_page
  end

  scenario "adds a new provider" do
    when_i_fill_in_a_valid_provider_details
    and_i_fill_in_a_valid_organisation_details
    and_i_fill_in_a_valid_site_details
    and_i_click_the_submit_button
    then_i_am_redirected_back_to_the_support_provider_show_page
    and_the_provider_is_created
  end

  scenario "I cannot edit a provider's name" do
    when_i_fill_in_an_invalid_provider_name
    and_i_click_the_submit_button
    then_i_see_the_error_summary
  end

private

  def when_i_visit_the_new_provider_page
    support_provider_new_page.load(recruitment_cycle_year: Settings.current_recruitment_cycle_year)
  end

  def when_i_fill_in_a_valid_provider_details
    support_provider_new_page.provider_name.set("My favourite provider")
    support_provider_new_page.provider_code.set("A32")
    support_provider_new_page.provider_type_scitt.click
    support_provider_new_page.provider_email.set("test@example.com")
    support_provider_new_page.provider_telephone.set("01392 000000")
  end

  def and_i_fill_in_a_valid_organisation_details
    support_provider_new_page.organisation_name.set("Organisation 1")
  end

  def and_i_fill_in_a_valid_site_details
    support_provider_new_page.site_code.set("Z")
    support_provider_new_page.site_location_name.set("The Green Academy")
    support_provider_new_page.site_address1.set("Poplar Drive")
    support_provider_new_page.site_address2.set("Blurton")
    support_provider_new_page.site_address3.set("Stoke-on-Trent")
    support_provider_new_page.site_address4.set("Staffordshire")
    support_provider_new_page.site_postcode.set("ST3 3AZ")
  end

  def and_i_click_on_the_change_link
    support_provider_show_page.edit_provider.click
  end

  def then_i_am_on_the_support_provider_new_page
    support_provider_new_page.load(id: @provider.id)
  end

  def and_i_click_the_submit_button
    support_provider_new_page.submit.click
  end

  def then_i_am_redirected_back_to_the_support_provider_show_page
    expect(support_provider_show_page).to be_displayed(id: Provider.last.id)
  end

  def and_the_provider_is_created
    expect(support_provider_show_page).to have_text("My favourite provider")
  end

  def when_i_fill_in_an_invalid_provider_name
    support_provider_new_page.provider_name.set(SecureRandom.hex(100))
  end

  def then_i_see_the_error_summary
    expect(support_provider_new_page.error_summary).to be_visible
  end
end
