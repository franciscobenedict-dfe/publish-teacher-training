# frozen_string_literal: true

require "rails_helper"

feature "Copying course information", { can_edit_current_and_next_cycles: false } do
  context "with accredited courses" do
    before do
      given_i_am_authenticated_as_an_accredited_provider_user
      and_there_is_an_accredited_course_i_want_to_edit
      when_i_visit_the_course_information_edit_page
    end

    include_context "copy_courses"

    scenario "the course does not display its own name in the copy list" do
      course_information_edit_page.load(
        provider_code: provider.provider_code, recruitment_cycle_year: provider.recruitment_cycle_year, course_code: course.course_code,
      )

      list_options = course_information_edit_page.copy_content.copy_options
      expect(Course.count).to eq 3
      expect(list_options.size).to eq 3
      expect(list_options.shift).to eq("Pick a course")
      expect(list_options.any? { |x| x[@course.name] }).to be_falsey
    end
  end

  context "with non accredited courses" do
    before do
      given_i_am_authenticated_as_a_provider_user
      and_there_is_a_course_i_want_to_edit
      when_i_visit_the_course_information_edit_page
    end

    include_context "copy_courses"

    scenario "the course does not display its own name in the copy list" do
      course_information_edit_page.load(
        provider_code: provider.provider_code, recruitment_cycle_year: provider.recruitment_cycle_year, course_code: course.course_code,
      )

      list_options = course_information_edit_page.copy_content.copy_options
      expect(Course.count).to eq 3
      expect(list_options.size).to eq 3
      expect(list_options.shift).to eq("Pick a course")
      expect(list_options.any? { |x| x[@course.name] }).to be_falsey
    end
  end

  def given_i_am_authenticated_as_a_provider_user
    given_i_am_authenticated(user: create(:user, :with_provider))
  end

  def and_there_is_a_course_i_want_to_edit
    given_a_course_exists(enrichments: [build(:course_enrichment, :published)])
  end

  def given_i_am_authenticated_as_an_accredited_provider_user
    given_i_am_authenticated(user: create(:user, :with_accredited_provider))
  end

  def and_there_is_an_accredited_course_i_want_to_edit
    given_a_course_exists(:with_accrediting_provider, enrichments: [build(:course_enrichment, :published)])
  end

  def when_i_visit_the_course_information_edit_page
    course_information_edit_page.load(
      provider_code: provider.provider_code, recruitment_cycle_year: provider.recruitment_cycle_year, course_code: course.course_code,
    )
  end

  def provider
    @provider ||= @current_user.providers.first
  end
end
