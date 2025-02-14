# frozen_string_literal: true

require_relative "../sections/location"

module PageObjects
  module Publish
    class LocationsIndex < PageObjects::Base
      set_url "/publish/organisations/{provider_code}/{recruitment_cycle_year}/locations"

      sections :locations, Sections::Location, ".location-row"

      element :add_location, ".govuk-button", text: "Add location"
    end
  end
end
