# frozen_string_literal: true
require "rails_helper"
require "capybara/rspec"

Capybara.javascript_driver = :cuprite
Capybara.always_include_port = false

RSpec.describe "Smoke test", type: :system, js: true, smoke_test: true do
  it "works as expected" do
    when_i_visit_the_home_page
    then_i_see_the_home_page
  end

  it "/health/all returns 200" do
    page.visit("#{ENV["HOSTING_DOMAIN"]}/health/all")
    expect(page).to have_content("Application is running")
  end

  private

  def when_i_visit_the_home_page
    page.visit("#{ENV["HOSTING_DOMAIN"]}/")
  end

  def then_i_see_the_home_page
    expect(page).to have_content("Access your teaching profile")
  end
end
