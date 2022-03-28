require "rails_helper"

RSpec.describe "Optix Webhooks" do
  describe "POST /api/v1/webhooks/optix" do
    describe "receiving a checkin" do
      it "creates a user if needed" do
        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/webhooks/optix", params: '{"check_in_datetime": "2022-03-23 16:12", "check_in_timestamp": "1648051960", "checkin_id": "216292", "created_datetime": "2022-03-23 16:12", "member_email": "member@example.com", "member_full_name": "Sam Body", "member_last_name": "Body", "member_name": "Sam", "venue_id": "24263", "venue_name": "BizCo HQ", "workspace_name": "BizCo"}', headers: headers

        expect(response.status).to eq(200)
        user = User.find_by(email: "member@example.com")
        expect(user.name).to eq("Sam Body")
      end

      it "updates a user's name if blank" do
        user = User.create!(email: "member@example.com", name: "")

        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/webhooks/optix", params: '{"check_in_datetime": "2022-03-23 16:12", "check_in_timestamp": "1648051960", "checkin_id": "216292", "created_datetime": "2022-03-23 16:12", "member_email": "member@example.com", "member_full_name": "Sam Body", "member_last_name": "Body", "member_name": "Sam", "venue_id": "24263", "venue_name": "BizCo HQ", "workspace_name": "BizCo"}', headers: headers

        expect(response.status).to eq(200)
        user.reload
        expect(user.name).to eq("Sam Body")
      end

      it "does not update a user's name if present" do
        user = User.create!(email: "member@example.com", name: "Original Name")

        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/webhooks/optix", params: '{"check_in_datetime": "2022-03-23 16:12", "check_in_timestamp": "1648051960", "checkin_id": "216292", "created_datetime": "2022-03-23 16:12", "member_email": "member@example.com", "member_full_name": "Sam Body", "member_last_name": "Body", "member_name": "Sam", "venue_id": "24263", "venue_name": "BizCo HQ", "workspace_name": "BizCo"}', headers: headers

        expect(response.status).to eq(200)
        user.reload
        expect(user.name).to eq("Original Name")
      end
    end

    describe "receiving a new member" do
      it "creates a user if needed" do
        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/webhooks/optix", params: '{"city": "", "email": "member@example.com", "first_name": "", "full_name": " ", "last_name": "", "member_id": "161128", "phone": "", "venue_id": "24263", "venue_name": "BizCo"}', headers: headers

        expect(response.status).to eq(200)
        user = User.find_by(email: "member@example.com")
        expect(user).not_to be(nil)
      end

      it "does not overwrite a user's name if they already exist" do
        user = User.create!(email: "member@example.com", name: "Original Name")

        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/webhooks/optix", params: '{"city": "", "email": "member@example.com", "first_name": "", "full_name": " ", "last_name": "", "member_id": "161128", "phone": "", "venue_id": "24263", "venue_name": "BizCo"}', headers: headers

        expect(response.status).to eq(200)
        user = User.find_by(email: "member@example.com")
        expect(user.name).to eq("Original Name")
      end
    end
  end
end
