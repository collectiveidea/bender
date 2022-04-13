require "rails_helper"

RSpec.describe "Taps API" do
  describe "GET /api/vi/taps" do
    let!(:keg) { FactoryBot.create(:keg) }

    it "returns all active taps as json" do
      get "/api/v1/taps"

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response.map { |u| u["name"] }).to include(keg.beer_tap.name)
    end
  end
end
