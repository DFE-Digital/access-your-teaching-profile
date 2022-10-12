require "rails_helper"

RSpec.describe "Static markdown pages" do
  include Capybara::RSpecMatchers

  describe "GET /accessibility" do
    it "renders accessibility guidance" do
      get "/accessibility"

      expect(response).to be_successful
      expect(response.body).to have_selector("h1", text: "Accessibility")
      expect(response.body).to have_selector("h2", text: "Using this service")
    end
  end

  describe "GET /cookies" do
    it "renders the cookies guidance" do
      get "/cookies"

      expect(response).to be_successful
      expect(response.body).to have_selector("h1", text: "Cookies")
      expect(response.body).to have_selector("h2", text: "Essential cookies")
      expect(response.body).to have_selector("table thead th", text: "Expires")
      expect(response.body).to have_selector(
        "p",
        text: /Access your teaching profile service/
      )
    end
  end

  describe "GET /privacy" do
    it "renders privacy guidance" do
      get "/privacy"

      expect(response).to be_successful
      expect(response.body).to have_selector("h1", text: "Privacy notice")
      expect(response.body).to have_selector("h2", text: "What data we collect")
      expect(response.body).to have_selector(
        "p",
        text: /Access your teaching profile service/
      )
    end
  end
end
