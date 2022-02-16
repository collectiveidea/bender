require "rails_helper"

describe "View Keg" do
  let(:tap) { FactoryBot.create(:beer_tap) }
  let(:keg) { FactoryBot.create(:keg, name: "Better Beer") }

  before do
    keg.tap_it(tap.id)
  end

  it "shows immediately after a keg has been tapped" do
    visit keg_path(keg)

    within(".page-header h1") do
      expect(page).to have_content("Better Beer")
    end

    expect(page).to have_content "Leaderboard"
    expect(page).to have_content "Stats"
    expect(page).to have_content "Beer Temperature"

    stats = Dom::KegStats.first
    expect(stats.poured).to eq(0)
    expect(stats.remaining).to eq(keg.capacity)
    expect(stats.pours).to eq(0)
    expect(stats.average_pour_volume).to eq(0.0)
  end

  context "after pours" do
    it "shows pours and leaderboard correctly" do
      User.create(id: 0, name: "Guest")
      john = FactoryBot.create(:user, name: "John")
      jane = FactoryBot.create(:user, name: "Jane")
      johns_pour = FactoryBot.create(:pour, keg_id: keg.id, user_id: john.id, volume: 6.2)

      # if faye was running in test env this could be in the before
      visit keg_path(keg)

      leader = Dom::LeaderBoardConsumer.first
      expect(leader.name).to eq("John")
      expect(leader.total).to eq(6.2)
      expect(leader.pours).to eq(1)

      janes_pour = FactoryBot.create(:pour, keg_id: keg.id, user_id: jane.id, volume: 7.9)

      # if faye was running in test env this could be in the before
      visit keg_path(keg)

      new_leader = Dom::LeaderBoardConsumer.first
      expect(new_leader.name).to eq("Jane")
      expect(new_leader.total).to eq(7.9)
      expect(new_leader.pours).to eq(1)

      expect(Dom::LeaderBoardConsumer.all[1].name).to eq("John")

      stats = Dom::KegStats.first
      expect(stats.poured).to eq(14)
      expect(stats.remaining).to eq(keg.remaining.round)
      expect(stats.pours).to eq(2)
      expect(stats.average_pour_volume).to eq(7.0)
    end
  end
end
