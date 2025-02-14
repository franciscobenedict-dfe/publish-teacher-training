require "rails_helper"

feature "Searching by location" do
  before do
    stub_geocoder_lookup

    given_i_visit_the_start_page
    and_i_select_the_location_radio_button
  end

  scenario "attempting to search without query" do
    and_i_click_continue
    then_i_should_see_a_missing_location_validation_error
  end

  scenario "persists the correct location options in the url" do
    when_i_enter_a_location
    and_i_click_continue
    then_i_should_see_the_age_groups_form
    and_the_correct_age_group_form_page_url_and_query_params_are_present

    when_i_click_back
    then_i_should_see_the_start_page
    and_the_location_radio_button_is_selected
  end

private

  def given_i_visit_the_start_page
    courses_by_location_or_training_provider_page.load
  end

  def and_i_select_the_location_radio_button
    courses_by_location_or_training_provider_page.by_city_town_or_postcode_radio.choose
  end

  def and_i_click_continue
    courses_by_location_or_training_provider_page.continue.click
  end

  def then_i_should_see_a_missing_location_validation_error
    expect(page).to have_content("Enter a city, town or postcode")
  end

  def when_i_enter_a_location
    courses_by_location_or_training_provider_page.location.set("Yorkshire")
  end

  def then_i_should_see_the_age_groups_form
    expect(page).to have_content(I18n.t("find.age_groups.title"))
  end

  def and_the_correct_age_group_form_page_url_and_query_params_are_present
    URI(current_url).then do |uri|
      expect(uri.path).to eq("/find/age-groups")
      expect(uri.query).to eq("c=England&l=1&latitude=51.4524877&loc=AA+Teamworks+W+Yorks+SCITT%2C+School+Street%2C+Greetland%2C+Halifax%2C+West+Yorkshire+HX4+8JB&longitude=-0.1204749&lq=Yorkshire&radius=50&sortby=distance")
    end
  end

  def then_i_should_see_the_start_page
    expect(courses_by_location_or_training_provider_page).to be_displayed
  end

  def when_i_click_back
    click_link "Back"
  end

  def and_the_location_radio_button_is_selected
    expect(courses_by_location_or_training_provider_page.by_city_town_or_postcode_radio).to be_checked
  end
end
