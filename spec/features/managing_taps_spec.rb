require 'spec_helper'

describe 'Managing taps' do
  it 'allows a user to add a tap' do
    visit '/admin/beer_taps'

    click_link 'New'

    fill_in 'Name', with: 'Main Tap'
    fill_in 'GPIO Pin', with: '17'
    fill_in 'mL per tick', with: '0.17857'

    click_button 'Create'

    expect(page).to have_content('Admin Taps > Main Tap')
  end

  it 'allows a user to edit an existing tap' do
    beer_tap = FactoryGirl.create(:beer_tap, name: 'Main Tap')

    visit '/admin/beer_taps'
    click_link 'Main Tap'
    click_link 'Edit'

    fill_in 'Name', with: 'Left Tap'
    click_button 'Update'

    expect(page).to have_content('Admin Taps > Left Tap')
  end
end