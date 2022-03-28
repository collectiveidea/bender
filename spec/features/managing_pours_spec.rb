require "rails_helper"

describe "Managing pours" do
  let(:beer_tap) { FactoryBot.create(:beer_tap, name: "Main Tap") }
  let(:keg) { FactoryBot.create(:keg, name: "Better Beer") }

  before do
    User.create(id: 0, name: "Guest")
    keg.tap_it(beer_tap.id)
  end

  it "a new drinker can join" do
    visit "/"

    click_link "Start Pour"
    click_link "New User"

    fill_in "Name", with: "Johnny"
    fill_in "Email", with: "johnny@quest.com"
    click_button "Create"

    expect(current_path).to eq("/")

    click_link "Start Pour"
    click_link "Johnny"

    expect(page).to have_content("Pour Started")
  end

  it "allows an existing user to claim a pour" do
    user = FactoryBot.create(:user, name: "Johnny")
    pour = FactoryBot.create(:pour, keg: keg, volume: 4.0, user_id: 0)

    visit "/"

    click_link "Claim pour"
    click_link "Johnny"

    expect(page).to have_content("Johnny poured a 4.0oz Better Beer")
  end

  it "redirects to the appropriate place after claiming a pour" do
    user = FactoryBot.create(:user, name: "Johnny")
    pour = FactoryBot.create(:pour, keg: keg, volume: 4.0, user_id: 0)

    source = url_for([:admin, keg])

    visit source

    click_link "Assign pour"
    click_link "Johnny"

    expect(page.current_url).to eq(source)
  end

  it "prevents a user with zero credits from starting a pour" do
    user = FactoryBot.create(:user, name: "Johnny", credits: 0)

    visit "/"
    click_link "Start Pour"
    click_link "Johnny"

    expect(page.status_code).to eq(403)
  end
end
