# frozen_string_literal: true

require "rails_helper"

feature "View an allocation" do
  before do
    given_i_am_authenticated(user: create(:user, :admin))
    and_there_are_providers_with_allocations_and_uplifts
    when_i_visit_the_support_allocations_show_page
  end

  scenario "i can view the providers' allocations" do
    then_i_see_the_provider_and_their_allocations
  end

private

  def and_there_are_providers_with_allocations_and_uplifts
    @provider = create(:provider)
    @allocation = create(:allocation, provider: @provider, number_of_places: 5)
  end

  def when_i_visit_the_support_allocations_show_page
    support_allocations_show_page.load(recruitment_cycle_year: Settings.current_recruitment_cycle_year, id: @allocation.id)
  end

  def then_i_see_the_provider_and_their_allocations
    expect(support_allocations_show_page).to have_content @provider.provider_name
    expect(support_allocations_show_page).to have_content "Allocations"
    expect(support_allocations_show_page).to have_link "Change"
  end
end
