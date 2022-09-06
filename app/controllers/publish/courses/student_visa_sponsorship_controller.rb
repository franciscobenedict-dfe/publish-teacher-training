module Publish
  module Courses
    class StudentVisaSponsorshipController < PublishController
      include CourseBasicDetailConcern

      def new
        authorize(@provider, :can_create_course?)
        @course.can_sponsor_student_visa = @provider.can_sponsor_student_visa
        @course_student_visa_sponsorship_form = CourseStudentVisaSponsorshipForm.new(@course)
        return if course.is_fee_based?

        redirect_to next_step
      end

      def edit
        authorize(provider)

        @course_student_visa_sponsorship_form = CourseStudentVisaSponsorshipForm.new(@course)
      end

      def update
        authorize(provider)
        @course_student_visa_sponsorship_form = CourseStudentVisaSponsorshipForm.new(@course, params: student_visa_sponsorship_params)
        if @course_student_visa_sponsorship_form.save!
          course_description_success_message("student visa")

          redirect_to details_publish_provider_recruitment_cycle_course_path(
            provider.provider_code,
            recruitment_cycle.year,
            course.course_code,
          )
        else
          render :edit
        end
      end

    private

      def student_visa_sponsorship_params
        return { visa_sponsorship: nil } if params[:publish_course_student_visa_sponsorship_form].blank?

        params.require(:publish_course_student_visa_sponsorship_form).permit(*CourseStudentVisaSponsorshipForm::FIELDS)
      end

      def current_step
        :can_sponsor_student_visa
      end

      def error_keys
        [:can_sponsor_student_visa]
      end
    end
  end
end
