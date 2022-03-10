require "rails_helper"

RSpec.describe "User API" do
  describe "GET /api/vi/users" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:hidden_user) { FactoryBot.create(:user, hidden: true) }

    it "returns all active users as json" do
      get "/api/v1/users"

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response.map{|u| u["id"]}).to include(user.id)
      expect(json_response.map{|u| u["id"]}).not_to include(hidden_user.id)
    end

    it "returns a single user as json by id" do
      get "/api/v1/users/#{user.id}"

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to equal(user.id)
    end

    it "returns a single user as json by id even if hidden" do
      get "/api/v1/users/#{hidden_user.id}"

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to equal(hidden_user.id)
    end

    it "returns a single user as json by rfid" do
      get "/api/v1/users/#{user.rfid}"

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to equal(user.id)
    end
  end
end
