module Find
  module Search
    class LocationsController < Find::ApplicationController
      include FilterParameters

      before_action :providers
      before_action :build_results_filter_query_parameters

      def start; end

      def new; end

      def create
        # if searching by specific provider we have to filter params
        if provider_option_selected?
          redirect_to next_step(params)
          return
        end

        form_params = strip(filter_params.clone).merge(sortby: ResultsView::DISTANCE)
        form_object = LocationFilterForm.new(form_params)

        if form_object.valid?
          parameters_with_geocode_added_and_previous_removed = remove_previous_parameters(form_params.merge(form_object.params))
          redirect_to(next_step(parameters_with_geocode_added_and_previous_removed))
        else
          flash[:error] = form_object.errors
          back_to_current_page_if_error(merge_previous_parameters(form_params))
        end
      end

    private

      def providers
        @providers ||= RecruitmentCycle.current.providers.by_name_ascending
      end

      def find_courses_by_location_or_training_provider_form_params
        params[:find_courses_by_location_or_training_provider_form]
          .permit(:prev_l, :prev_loc, :prev_lng, :prev_lat, :prev_rad, :prev_query, :prev_lq)
      end

      def build_results_filter_query_parameters
        @results_filter_query_parameters = merge_previous_parameters(
          ResultsView.new(query_parameters: request.query_parameters).query_parameters_with_defaults,
        )
      end

      def location_option_selected?
        filter_params[:l] == "1"
      end

      def across_england_option_selected?
        filter_params[:l] == "2"
      end

      def provider_option_selected?
        filter_params[:l] == "3"
      end

      def strip(params)
        params.reject { |_, v| v == "" }
      end

      def next_step(all_params)
        find_age_groups_path(get_params_for_selected_option(all_params))
      end

      def get_params_for_selected_option(all_params)
        if location_option_selected?
          all_params.except(:query).merge(rad: ResultsView::MILES)
        elsif across_england_option_selected?
          all_params.except(:lat, :lng, :rad, :loc, :lq, :query, :sortby)
        elsif provider_option_selected?
          p = filter_params.except(:lat, :lng, :rad, :loc, :lq)
          remove_previous_parameters(p)
        end
      end

      def back_to_current_page_if_error(form_params)
        redirect_to find_locations_path(form_params.merge(l: params[:l]))
      end
    end
  end
end
