require 'spec_helper'

describe 'Managing kegs' do
  it 'allows a user to add a keg' do
    visit '/admin/kegs'
    click_link 'New'

    fill_in 'Name', with: 'Better Beer'
    fill_in 'Description', with: 'Need I say more'
    select '1/6 Barrel', from: 'Capacity'

    click_button 'Create'

    expect(page).to have_content('Admin Kegs > Better Beer')
  end

  it 'allows a user to edit a keg' do
    FactoryGirl.create(:keg, name: 'Better Beer')
    visit '/admin/kegs'
    click_link 'Better Beer'
    click_link 'Edit'

    fill_in 'Name', with: 'Betterer Beer'

    click_button 'Update'

    expect(page).to have_content('Admin Kegs > Betterer Beer')
  end

  it 'allows a user to tap a keg' do
    FactoryGirl.create(:keg, name: 'Better Beer')
    FactoryGirl.create(:beer_tap, name: 'Main Tap')

    visit '/admin/kegs'
    click_link 'Better Beer'
    click_link 'Tap Keg'
    select 'Main Tap', from: 'What tap are we using?'
    click_button 'Tap that keg'

    expect(page).to have_content("Untap Keg")
  end

  it 'allows a user to untap a keg' do
    keg = FactoryGirl.create(:keg, name: 'Better Beer')
    beer_tap = FactoryGirl.create(:beer_tap, name: 'Main Tap')
    keg.tap_it(beer_tap.id)

    visit '/admin/kegs'
    click_link 'Better Beer'
    click_link 'Untap Keg'

    expect(page).to have_content("Tap Keg")
  end
end