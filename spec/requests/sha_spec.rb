require "rails_helper"

RSpec.describe "Git SHA", type: :request do
  it "responds successfully" do
    get "/_sha"
    expect(response).to have_http_status(:ok)
  end

  it "responds with the current Git SHA" do
    get "/_sha"
    expect(response.body).to eq(`git rev-parse HEAD`.chomp)
  end
end
