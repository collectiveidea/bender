require "spec_helper"

RSpec.describe "Authenticate user" do
  it "returns a user's data given the user's rfid" do
    user = FactoryGirl.create(:user, rfid: "123456")
    post "/api/v1/auth", {rfid: user.rfid}

    json_response = JSON.parse(response.body).with_indifferent_access
    expect(json_response[:id]).to eq(user.id)
  end
end
