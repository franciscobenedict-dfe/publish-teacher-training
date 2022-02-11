module Publish
  module Courses
    class ConfirmationController < PublishController
      include CourseBasicDetailConcern

      decorates_assigned :course

      def confirmation
        authorize(provider, :can_create_course?)
        recruitment_cycle
      end

    private

      def provider
        @provider ||= Provider
          .includes(courses: %i[sites site_statuses enrichments provider])
          .find_by!(recruitment_cycle: recruitment_cycle, provider_code: params[:provider_code])
      end

      def recruitment_cycle
        @recruitment_cycle ||= RecruitmentCycle.find_by(
          year: params[:recruitment_cycle_year],
        ) || RecruitmentCycle.current_recruitment_cycle
      end
    end
  end
end
