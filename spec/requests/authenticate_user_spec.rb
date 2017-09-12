require "spec_helper"

RSpec.describe "Authenticate user" do
  it "returns a user's data given the user's rfid" do
    user = FactoryGirl.create(:user, rfid: "123456", credits: 3)
    post "/api/v1/auth", {rfid: user.rfid}

    json_response = JSON.parse(response.body).with_indifferent_access
    expect(json_response[:id]).to eq(user.id)
  end

  it "returns a forbidden when the user doesn't have credits" do
    user = FactoryGirl.create(:user, rfid: "123456", credits: 0)
    post "/api/v1/auth", {rfid: user.rfid}

    expect(response.status).to eq(403)
    expect(response.body).to eq("Insufficient credits remaining")
  end
end
