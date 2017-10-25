require 'spec_helper'

describe "View Keg" do
  let(:tap) { FactoryGirl.create(:beer_tap) }
  let(:keg) { FactoryGirl.create(:keg, name: "Better Beer") }

  before do
    keg.tap_it(tap.id)
  end

  it "shows immediately after a keg has been tapped" do
    visit keg_path(keg)

    within(".page-header h1") do
      page.should have_content("Better Beer")
    end

    page.should have_content "Leaderboard"
    page.should have_content "Stats"
    page.should have_content "Beer Temperature"

    stats = Dom::KegStats.first
    stats.poured.should eq(0)
    stats.remaining.should eq(keg.capacity)
    stats.pours.should eq(0)
    stats.average_pour_volume.should eq(0.0)
  end

  context "after pours" do
    it "shows pours and leaderboard correctly" do
      User.create(id: 0, name: "Guest")
      john = FactoryGirl.create(:user, name: "John")
      jane = FactoryGirl.create(:user, name: "Jane")
      johns_pour = FactoryGirl.create(:pour, keg_id: keg.id, user_id: john.id, volume: 6.2)

      # if faye was running in test env this could be in the before
      visit keg_path(keg)

      leader = Dom::LeaderBoardConsumer.first
      leader.name.should eq("John")
      leader.total.should eq(6.2)
      leader.pours.should eq(1)

      janes_pour = FactoryGirl.create(:pour, keg_id: keg.id, user_id: jane.id, volume: 7.9)

      # if faye was running in test env this could be in the before
      visit keg_path(keg)

      new_leader = Dom::LeaderBoardConsumer.first
      new_leader.name.should eq("Jane")
      new_leader.total.should eq(7.9)
      new_leader.pours.should eq(1)

      Dom::LeaderBoardConsumer.all[1].name.should eq("John")

      stats = Dom::KegStats.first
      stats.poured.should eq(14)
      stats.remaining.should eq(keg.remaining.round)
      stats.pours.should eq(2)
      stats.average_pour_volume.should eq(7.0)
    end
  end
end
