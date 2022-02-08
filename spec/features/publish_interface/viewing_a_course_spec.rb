# frozen_string_literal: true

require "rails_helper"

feature "Course show" do
  before do
    given_i_am_authenticated_as_a_provider_user
    when_i_visit_the_course_page
  end

  let(:course) {
    build(:course)
  }

  scenario "i can view the course basic details" do
    and_i_click_on_basic_details
    then_i_see_the_course_basic_details
  end

  describe "with a fee paying course" do
    let(:course) {
      build(:course, enrichments: [course_enrichment], funding_type: "fee")
    }

    scenario "i can view a fee course" do
      then_i_should_see_the_description_of_the_fee_course
    end
  end

  describe "with a salary paying course" do
    let(:course) {
      build(:course, enrichments: [course_enrichment], funding_type: "salary")
    }

    scenario "i can view a salary course" do
      then_i_should_see_the_description_of_the_salary_course
    end
  end

  def and_i_click_on_basic_details
    publish_provider_courses_show_page.basic_details_link.click
  end

  def then_i_see_the_course_basic_details
    expect(page).to have_current_path("/publish/organisations/#{provider.provider_code}/#{provider.recruitment_cycle_year}/courses/#{course.course_code}/details")
  end

  def course_enrichment
    @course_enrichment ||= build(:course_enrichment, :published, course_length: :TwoYears, fee_uk_eu: 9250, fee_international: 14000)
  end

  def given_i_am_authenticated_as_a_provider_user
    given_i_am_authenticated(
      user: create(
        :user,
        providers: [
          create(:provider, sites: [build(:site)], courses: [course]),
        ],
      ),
    )
  end

  def when_i_visit_the_course_page
    publish_provider_courses_show_page.load(
      provider_code: provider.provider_code, recruitment_cycle_year: provider.recruitment_cycle_year, course_code: course.course_code,
    )
  end

  def then_i_should_see_the_description_of_the_fee_course
    expect(publish_provider_courses_show_page.caption).to have_content(
      course.description,
    )
    expect(publish_provider_courses_show_page.title).to have_content(
      "#{course.name} (#{course.course_code})",
    )
    expect(publish_provider_courses_show_page.about_course).to have_content(
      course_enrichment.about_course,
    )
    expect(publish_provider_courses_show_page.interview_process).to have_content(
      course_enrichment.interview_process,
    )
    expect(publish_provider_courses_show_page.how_school_placements_work).to have_content(
      course_enrichment.how_school_placements_work,
    )
    expect(publish_provider_courses_show_page.course_length).to have_content(
      "Up to 2 years",
    )
    expect(publish_provider_courses_show_page.fee_uk_eu).to have_content(
      "£9,250",
    )
    expect(publish_provider_courses_show_page.fee_international).to have_content(
      "£14,000",
    )
    expect(publish_provider_courses_show_page.fee_details).to have_content(
      course_enrichment.fee_details,
    )
    expect(publish_provider_courses_show_page).not_to have_salary_details

    expect(publish_provider_courses_show_page).to have_degree
    expect(publish_provider_courses_show_page).to have_gcse

    expect(publish_provider_courses_show_page.personal_qualities).to have_content(
      course_enrichment.personal_qualities,
    )
    expect(publish_provider_courses_show_page.other_requirements).to have_content(
      course_enrichment.other_requirements,
    )
  end

  def then_i_should_see_the_description_of_the_salary_course
    expect(publish_provider_courses_show_page.caption).to have_content(
      course.description,
    )
    expect(publish_provider_courses_show_page.title).to have_content(
      "#{course.name} (#{course.course_code})",
    )
    expect(publish_provider_courses_show_page.about_course).to have_content(
      course_enrichment.about_course,
    )
    expect(publish_provider_courses_show_page.interview_process).to have_content(
      course_enrichment.interview_process,
    )
    expect(publish_provider_courses_show_page.how_school_placements_work).to have_content(
      course_enrichment.how_school_placements_work,
    )
    expect(publish_provider_courses_show_page.course_length).to have_content(
      "Up to 2 years",
    )
    expect(publish_provider_courses_show_page).not_to have_fee_uk_eu

    expect(publish_provider_courses_show_page).not_to have_fee_international

    expect(publish_provider_courses_show_page).not_to have_fee_details
    expect(publish_provider_courses_show_page.salary_details).to have_content(
      course_enrichment.salary_details,
    )
    expect(publish_provider_courses_show_page).to have_degree
    expect(publish_provider_courses_show_page).to have_gcse
    expect(publish_provider_courses_show_page.personal_qualities).to have_content(
      course_enrichment.personal_qualities,
    )
    expect(publish_provider_courses_show_page.other_requirements).to have_content(
      course_enrichment.other_requirements,
    )
  end

  def provider
    @current_user.providers.first
  end
end
