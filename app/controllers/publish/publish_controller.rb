module Publish
  class PublishController < ApplicationController
    include SuccessMessage

    layout "publish"

    before_action :check_interrupt_redirects
    before_action :clear_previous_cycle_year_in_session, unless: -> { FeatureService.enabled?("rollover.can_edit_current_and_next_cycles") }

    after_action :verify_authorized

  private

    def provider
      @provider ||= recruitment_cycle.providers.find_by(provider_code: params[:provider_code] || params[:code])
    end

    def recruitment_cycle
      @recruitment_cycle ||= RecruitmentCycle.find_by!(year: cycle_year)
    end

    def cycle_year
      @cycle_year ||= params[:recruitment_cycle_year] || params[:year] || Settings.current_recruitment_cycle_year
    end

    def show_errors_on_publish?
      params[:display_errors].present?
    end

    def check_interrupt_redirects(use_redirect_back_to: true)
      if !current_user.accepted_terms?
        redirect_to publish_accept_terms_path
      elsif show_rollover_recruitment_page?
        redirect_to publish_rollover_recruitment_path
      elsif use_redirect_back_to
        redirect_to session[:redirect_back_to] if session[:redirect_back_to].present?
        session.delete(:redirect_back_to)
      end
    end

    def show_rollover_recruitment_page?
      FeatureService.enabled?("rollover.show_next_cycle_allocation_recruitment_page") &&
        current_user.current_rollover_recruitment_acceptance.blank?
    end

    def clear_previous_cycle_year_in_session
      return if session[:cycle_year].to_i == Settings.current_recruitment_cycle_year

      session[:cycle_year] = nil
    end
  end
end
