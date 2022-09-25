module Find
  module Search
    class SubjectsController < Find::ApplicationController
      include FilterParameters

      def index
        @subjects_form = SubjectsForm.new(subject_codes: params[:subject_codes], age_group: params[:age_group])
      end

      def create
        @subjects_form = SubjectsForm.new(subject_codes: sanitised_subject_codes, age_group: find_subjects_form_params[:age_group])

        if @subjects_form.valid?
          redirect_to course_results_path # TODO: create this
        else
          render :index
        end
      end

    private

      def sanitised_subject_codes
        find_subjects_form_params["subject_codes"].compact_blank!
      end

      def find_subjects_form_params
        params.require(:find_subjects_form)
          .permit(:age_group, :city_town_postcode_query, :find_courses, :school_uni_or_provider_query, subject_codes: [])
      end
    end
  end
end
