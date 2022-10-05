require "rails_helper"

RSpec.describe "Git SHA", type: :request do
  it "responds successfully" do
    get "/_sha"
    expect(response).to have_http_status(:ok)
  end

  it "responds with the current Git SHA" do
    allow(ENV).to receive(:fetch).with("GIT_SHA", "").and_return(
      "6f30ff56b31aed931866f8845a44ae9930934192"
    )

    get "/_sha"
    expect(response.body).to eq("6f30ff56b31aed931866f8845a44ae9930934192")
  end
end
