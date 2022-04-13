require "rails_helper"

RSpec.describe "User Stats API" do
  before do
    allow(FayeNotifier).to receive(:send_message).and_return(true)
  end

  describe "GET /api/vi/users/:id/stats" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:pour) { FactoryBot.create(:pour, user: user) }

    it "returns the user's stats as json" do
      get "/api/v1/users/#{user.id}/stats"

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response["email"]).to eq(user.email)
      expect(json_response["recent_pours"].first).to include(pour.volume.to_s)
    end
  end
end
