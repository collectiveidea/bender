require "rails_helper"

describe Keg do
  before do
    allow(FayeNotifier).to receive(:send_message).and_return(true)
  end

  it "calculates the total poured volume against the keg" do
    User.create(id: 0, name: "Guest")
    keg = FactoryBot.create(:keg)
    FactoryBot.create_list(:pour, 3, {keg_id: keg.id})
    FactoryBot.create(:pour)
    total_volume = Pour.where(keg_id: keg.id).to_a.sum { |p| p.volume }

    expect(keg.poured).to eq(total_volume)
  end

  it "calculates the remaining volume in the keg" do
    User.create(id: 0, name: "Guest")
    keg = FactoryBot.create(:keg, capacity: 100)
    FactoryBot.create_list(:pour, 3, {keg_id: keg.id})
    FactoryBot.create(:pour)
    total_volume = Pour.where(keg_id: keg.id).to_a.sum { |p| p.volume }

    expect(keg.remaining).to eq(100 - total_volume)
  end

  describe "start_pour" do
    it "starts a new pour for a guest user" do
      keg = FactoryBot.create(:keg, beer_tap: FactoryBot.create(:beer_tap))
      pour = keg.start_pour

      expect(pour).to_not be_a_new_record
      expect(pour.user_id).to eq(0)
    end

    it "starts a new pour for given user" do
      keg = FactoryBot.create(:keg, beer_tap: FactoryBot.create(:beer_tap))
      user = FactoryBot.create(:user)
      pour = keg.start_pour(user)

      expect(pour).to_not be_a_new_record
      expect(pour.user_id).to eq(user.id)
    end

    it "activates the valve for the keg's tap" do
      beer_tap = FactoryBot.create(:beer_tap)
      keg = FactoryBot.create(:keg, beer_tap: beer_tap)
      user = FactoryBot.create(:user)

      expect(beer_tap).to receive(:activate)

      keg.start_pour(user)
    end
  end
end
