require "rails_helper"

feature "Searching by provider" do
  before do
    given_there_is_a_provider_with_courses
  end

  scenario "persists the correct provider options in the url" do
    when_i_visit_the_start_page
    and_i_select_the_provider_radio_button
    and_i_click_continue
    then_i_should_see_a_missing_provider_validation_error

    when_i_select_the_provider
    and_i_click_continue
    then_i_should_see_the_age_groups_form
    and_the_correct_age_group_form_page_url_and_query_params_are_present

    when_i_click_back
    then_i_should_see_the_start_page
    and_the_provider_radio_button_is_selected
  end

private

  def given_there_is_a_provider_with_courses
    create(:course,
      :published,
      :salary_type_based,
      provider:,
      site_statuses: [build(:site_status, :findable)])
  end

  def when_i_visit_the_start_page
    courses_by_location_or_training_provider_page.load
  end

  def and_i_select_the_provider_radio_button
    courses_by_location_or_training_provider_page.by_school_uni_or_provider.choose
  end

  def and_i_click_continue
    courses_by_location_or_training_provider_page.continue.click
  end

  def then_i_should_see_a_missing_provider_validation_error
    expect(page).to have_content("Enter a provider name or code")
  end

  def when_i_select_the_provider
    courses_by_location_or_training_provider_page.provider_name.select(provider.provider_name)
  end

  def then_i_should_see_the_age_groups_form
    expect(page).to have_content(I18n.t("find.age_groups.title"))
  end

  def and_the_correct_age_group_form_page_url_and_query_params_are_present
    URI(current_url).then do |uri|
      expect(uri.path).to eq("/find/age-groups")
      expect(uri.query).to eq("l=3&provider.provider_name=Provider+1&sortby=distance")
    end
  end

  def then_i_should_see_the_start_page
    expect(courses_by_location_or_training_provider_page).to be_displayed
  end

  def when_i_click_back
    click_link "Back"
  end

  def and_the_provider_radio_button_is_selected
    expect(courses_by_location_or_training_provider_page.by_school_uni_or_provider).to be_checked
  end

  def provider
    @provider ||= create(:provider, provider_name: "Provider 1")
  end
end
