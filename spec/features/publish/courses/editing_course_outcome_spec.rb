# frozen_string_literal: true

require "rails_helper"

feature "Editing course outcome" do
  before do
    given_i_am_authenticated_as_a_provider_user
  end

  scenario "i can update the course outcome" do
    and_there_is_a_qts_course_i_want_to_edit
    when_i_visit_the_course_outcome_page
    and_i_update_the_course_outcome
    and_i_submit
    then_i_should_see_a_success_message
    and_the_course_outcome_is_updated
  end

  scenario "updating with invalid data" do
    and_there_is_a_course_with_no_outcome
    when_i_visit_the_course_outcome_page
    and_i_submit
    then_i_should_see_an_error_message
  end

  context "a course offering QTS" do
    scenario "shows the correct outcome options to choose from" do
      and_there_is_a_qts_course_i_want_to_edit
      when_i_visit_the_course_outcome_page
      then_i_am_shown_the_correct_qts_options
    end
  end

  context "a further education course not offering QTS" do
    scenario "shows the correct outcome options to choose from" do
      and_there_is_a_non_qts_course_i_want_to_edit
      when_i_visit_the_course_outcome_page
      then_i_am_shown_the_correct_non_qts_options
    end
  end

  def given_i_am_authenticated_as_a_provider_user
    given_i_am_authenticated(user: create(:user, :with_provider))
  end

  def and_there_is_a_qts_course_i_want_to_edit
    given_a_course_exists(:resulting_in_qts)
  end

  def and_there_is_a_non_qts_course_i_want_to_edit
    given_a_course_exists(:resulting_in_pgde, level: "further_education")
  end

  def and_there_is_a_course_with_no_outcome
    given_a_course_exists
    # There is a NOT NULL constraint on the outcome column, so we need to set it
    # to an out of range enum integer which will force a validation error
    @course.update_columns(qualification: 99)
  end

  def when_i_visit_the_course_outcome_page
    publish_course_outcome_page.load(
      provider_code: provider.provider_code, recruitment_cycle_year: provider.recruitment_cycle_year, course_code: course.course_code,
    )
  end

  def and_i_update_the_course_outcome
    publish_course_outcome_page.pgce_with_qts.choose
  end

  def and_i_submit
    publish_course_outcome_page.submit.click
  end

  def then_i_should_see_a_success_message
    expect(page).to have_content(I18n.t("success.saved"))
  end

  def and_the_course_outcome_is_updated
    expect(course.reload).to be_pgce_with_qts
  end

  def then_i_should_see_an_error_message
    expect(publish_course_outcome_page.error_messages).to include("Pick an outcome")
    expect(publish_course_outcome_page).to have_selector("#qualification-error")
  end

  def then_i_am_shown_the_correct_qts_options
    expect(publish_course_outcome_page.qualification_names).to match_array(
      ["QTS", "PGCE with QTS", "PGDE with QTS"],
    )
  end

  def then_i_am_shown_the_correct_non_qts_options
    expect(publish_course_outcome_page.qualification_names).to match_array(
      ["PGCE only (without QTS)", "PGDE only (without QTS)"],
    )
  end

  def provider
    @current_user.providers.first
  end
end
