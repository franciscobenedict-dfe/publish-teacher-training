module Providers
  module ProviderList
    class View < GovukComponent::Base
      include Support::TimeHelper

      def initialize(provider:)
        super(classes: classes, html_attributes: html_attributes)
        @provider = provider
      end

      def formatted_provider_type
        Provider.human_attribute_name(@provider.provider_type)
      end

      def formatted_accrediting_provider
        @provider.accredited_body? ? "Yes" : "No"
      end
    end
  end
end
