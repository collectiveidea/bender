require "rails_helper"

RSpec.describe "User API" do
  describe "GET /api/vi/users" do
    let!(:user) { FactoryBot.create(:user) }
    it "returns all users as json" do
      get "/api/v1/users"

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response.map{|u| u["id"]}).to include(user.id)
    end

    it "returns a single user as json by id" do
      get "/api/v1/users/#{user.id}"

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to equal(user.id)
    end

    it "returns a single user as json by rfid" do
      get "/api/v1/users/#{user.rfid}"

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to equal(user.id)
    end
  end
end
