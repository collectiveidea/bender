require "rails_helper"

RSpec.describe "Kegs API" do
  describe "GET /api/vi/kegs" do
    let!(:keg) { FactoryBot.create(:keg, name: "PBR") }

    it "returns all active kegs as json" do
      get "/api/v1/kegs"

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response.map{|u| u["name"]}).to include("PBR")
      tap_names = json_response.map{|u| u["beer_tap"]}.flatten.map{|t| t["name"] }
      expect(tap_names).to include(keg.beer_tap.name)
    end
  end

  describe "GET /api/vi/kegs/:id" do
    let!(:keg) { FactoryBot.create(:keg, name: "PBR") }

    it "returns the keg as json" do
      get "/api/v1/kegs/#{keg.id}"

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response["name"]).to eq("PBR")
    end
  end
end
