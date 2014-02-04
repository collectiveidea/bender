require 'spec_helper'

describe 'Managing pours' do
  let(:beer_tap) { FactoryGirl.create(:beer_tap, name: 'Main Tap') }
  let(:keg) { FactoryGirl.create(:keg, name: 'Better Beer') }

  before do
    keg.tap_it(beer_tap.id)
  end

  it 'a new drinker can join' do
    visit '/'

    click_link 'Beer Me'
    click_link 'New User'

    fill_in 'Name', with: 'Johnny'
    fill_in 'Email', with: 'johnny@quest.com'
    click_button 'Create'

    expect(current_path).to eq('/')

    click_link 'Beer Me'
    click_link 'Johnny'

    expect(page).to have_content('Pour Started')
  end

  it 'allows an existing user to claim a pour' do
    User.create(id: 0, name: 'Guest')
    user = FactoryGirl.create(:user, name: 'Johnny')
    pour = FactoryGirl.create(:pour, keg: keg, volume: 4.0, user_id: 0)

    visit '/'

    click_link 'Claim pour'
    click_link 'Johnny'

    expect(page).to have_content("Johnny poured a 4.0oz Better Beer")
  end
end