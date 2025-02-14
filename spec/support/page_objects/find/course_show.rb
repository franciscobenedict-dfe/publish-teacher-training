# frozen_string_literal: true

module PageObjects
  module Find
    class CourseShow < PageObjects::Base
      set_url "/find/course/{provider_code}/{course_code}"

      element :title, ".govuk-heading-xl"
      element :sub_title, "[data-qa=course__provider_name]"
      element :extended_qualification_descriptions, "[data-qa=course__extended_qualification_descriptions]"
      element :accredited_body, "[data-qa=course__accredited_body]"
      element :qualifications, "[data-qa=course__qualifications]"
      element :funding_option, "[data-qa=course__funding_option]"
      element :length, "[data-qa=course__length]"
      element :applications_open_from, "[data-qa=course__applications_open]"
      element :start_date, "[data-qa=course__start_date]"
      element :provider_website, "[data-qa=course__provider_website]"
      element :vacancies, "[data-qa=course__vacancies]"
      element :about_course, "[data-qa=course__about_course]"
      element :interview_process, "[data-qa=course__interview_process]"
      element :school_placements, "[data-qa=course__about_schools]"
      element :uk_fees, "[data-qa=course__uk_fees]"
      element :eu_fees, "[data-qa=course__eu_fees]"
      element :fee_details, "[data-qa=course__fee_details]"
      element :international_fees, "[data-qa=course__international_fees]"
      element :salary_details, "#section-salary"
      element :scholarship_amount, "[data-qa=course__scholarship_amount]"
      element :bursary_amount, "[data-qa=course__bursary_amount]"
      element :early_career_payment_details, "[data-qa=course__early_career_payment_details]"
      element :financial_support_details, "[data-qa=course__financial_support_details]"
      element :required_qualifications, "[data-qa=course__required_qualifications]"
      element :personal_qualities, "[data-qa=course__personal_qualities]"
      element :other_requirements, "[data-qa=course__other_requirements]"
      element :train_with_us, "[data-qa=course__about_provider]"
      element :about_accrediting_body, "[data-qa=course__about_accrediting_body]"
      element :international_students, "[data-qa=course__international_students]"
      element :train_with_disability, "[data-qa=course__train_with_disabilities]"
      element :contact_email, "[data-qa=provider__email]"
      element :contact_telephone, "[data-qa=provider__telephone]"
      element :contact_website, "[data-qa=provider__website]"
      element :contact_address, "[data-qa=provider__address]"
      element :course_advice, "#section-advice"
      element :course_apply, "#section-apply"
      element :apply_link, "a[data-qa=course__apply_link]"
      element :back_link, "[data-qa=page-back]"
      element :end_of_cycle_notice, "[data-qa=course__end_of_cycle_notice]"
      element :feedback_link, "[data-qa=feedback-link]"
      element :age_range, "[data-qa=course__age_range]"
    end
  end
end
