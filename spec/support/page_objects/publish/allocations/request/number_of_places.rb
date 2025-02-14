# frozen_string_literal: true

module PageObjects
  module Publish
    module Allocations
      module Request
        class NumberOfPlaces < PageObjects::Base
          set_url "/publish/organisations/{provider_code}/{recruitment_cycle_year}/allocations/request"

          element :header, "h1"
          element :number_of_places_field, "#number-of-places-field"
          element :continue, ".govuk-button", text: "Continue"
        end
      end
    end
  end
end
