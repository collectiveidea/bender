require "rails_helper"

RSpec.describe "Pours API" do
  before do
    allow(FayeNotifier).to receive(:send_message).and_return(true)
  end

  describe "GET /api/vi/pours" do
    let!(:pour) { FactoryBot.create(:pour) }

    it "returns pours as json" do
      get "/api/v1/pours"

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response.map { |u| u["volume"] }).to include(pour.volume.to_s)
    end

    it "returns pours for a date range as json" do
      pour_in = FactoryBot.create(:pour, created_at: 15.minutes.ago)
      pour_out = FactoryBot.create(:pour, created_at: 5.minutes.ago)

      get "/api/v1/pours", params: {start_time: 20.minutes.ago, end_time: 10.minutes.ago}

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response.map { |u| u["volume"] }).to include(pour_in.volume.to_s)
      expect(json_response.map { |u| u["volume"] }).not_to include(pour_out.volume.to_s)
    end
  end

  describe "sorted pours" do
    let!(:pour_in) { FactoryBot.create(:pour, created_at: 15.minutes.ago) }
    let!(:pour_out) { FactoryBot.create(:pour, created_at: 5.minutes.ago) }

    describe "GET /api/vi/pours/by_beer" do
      it "returns pours by beer as json" do
        get "/api/v1/pours/by_beer", params: {start_time: 20.minutes.ago, end_time: 10.minutes.ago}

        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)
        expect(json_response.map { |u| u.first }).to include(pour_in.keg.name)
        expect(json_response.map { |u| u.first }).not_to include(pour_out.keg.name)
      end
    end

    describe "GET /api/vi/pours/by_user" do
      it "returns pours by user as json" do
        get "/api/v1/pours/by_user", params: {start_time: 20.minutes.ago, end_time: 10.minutes.ago}

        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)
        expect(json_response.map { |u| u["email"] }).to include(pour_in.user.email)
        expect(json_response.map { |u| u["email"] }).not_to include(pour_out.user.email)
      end
    end
  end
end
