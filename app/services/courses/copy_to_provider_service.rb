module Courses
  class CopyToProviderService
    def initialize(sites_copy_to_course:, enrichments_copy_to_course:, force:)
      @sites_copy_to_course = sites_copy_to_course
      @enrichments_copy_to_course = enrichments_copy_to_course
      @force = force
    end

    def execute(course:, new_provider:)
      return unless course.rollable? || force
      return if course_code_already_exists_on_provider?(course:, new_provider:)

      new_course = nil

      Course.transaction do
        new_course = course.dup
        new_course.uuid = nil
        new_course.provider = new_provider
        year_differential = new_course.recruitment_cycle.year.to_i - course.recruitment_cycle.year.to_i
        new_course.applications_open_from = adjusted_applications_open_from_date(course, year_differential)
        new_course.start_date = course.start_date + year_differential.year
        new_course.subjects = course.subjects
        new_course.can_sponsor_skilled_worker_visa = course.can_sponsor_skilled_worker_visa
        new_course.can_sponsor_student_visa = course.can_sponsor_student_visa
        new_course.save!(validate: false)

        copy_latest_enrichment_to_course(course, new_course)

        course.sites.each do |site|
          new_site = new_provider.sites.find_by(code: site.code)

          @sites_copy_to_course.execute(new_site:, new_course:) if new_site.present?
        end
      end
      new_course
    end

  private

    attr_reader :sites_copy_to_course, :enrichments_copy_to_course, :force

    def course_code_already_exists_on_provider?(course:, new_provider:)
      new_provider.courses.with_discarded.where(course_code: course.course_code).any?
    end

    def copy_latest_enrichment_to_course(course, new_course)
      last_enrichment = course.enrichments.most_recent.first
      return if last_enrichment.blank?

      @enrichments_copy_to_course.execute(enrichment: last_enrichment, new_course:)
    end

    def adjusted_applications_open_from_date(course, year_differential)
      return current_cycle.application_start_date if course.applications_open_from.blank? && next_cycle.blank?

      return course.applications_open_from if next_cycle.blank?

      if course.applications_open_from + year_differential.year >= next_cycle.application_start_date
        course.applications_open_from + year_differential.year
      else
        next_cycle.application_start_date
      end
    end

    def next_cycle
      @next_cycle ||= RecruitmentCycle.next_recruitment_cycle
    end

    def current_cycle
      @current_cycle ||= RecruitmentCycle.current_recruitment_cycle
    end
  end
end
