require 'spec_helper'

describe Keg do
  it 'calculates the total poured volume against the keg' do
    keg = FactoryGirl.create(:keg)
    FactoryGirl.create_list(:pour, 3, {keg_id: keg.id})
    FactoryGirl.create(:pour)
    total_volume = Pour.where(keg_id: keg.id).to_a.sum {|p| p.volume }

    expect(keg.poured).to eq(total_volume)
  end

  it 'calculates the remaining volume in the keg' do
    keg = FactoryGirl.create(:keg, capacity: 100)
    FactoryGirl.create_list(:pour, 3, {keg_id: keg.id})
    FactoryGirl.create(:pour)
    total_volume = Pour.where(keg_id: keg.id).to_a.sum {|p| p.volume }

    expect(keg.remaining).to eq(100 - total_volume)
  end

  describe 'start_pour' do
    it 'starts a new pour for a guest user' do
      keg = FactoryGirl.create(:keg)
      pour = keg.start_pour

      expect(pour).to_not be_a_new_record
      expect(pour.user_id).to eq(0)
    end

    it 'starts a new pour for given user' do
      keg = FactoryGirl.create(:keg)
      user = FactoryGirl.create(:user)
      pour = keg.start_pour(user)

      expect(pour).to_not be_a_new_record
      expect(pour.user_id).to eq(user.id)
    end
  end
end
