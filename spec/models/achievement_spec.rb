require 'spec_helper'

describe Achievement do
  before :all do
    Keg.delete_all
    User.delete_all
    Pour.delete_all


    FactoryGirl.create(:keg, id: 1, name: "Keg1")
    FactoryGirl.create(:keg, id: 2, name: "Keg2")

    FactoryGirl.create(:user, id: 0, name: "Guest")
    FactoryGirl.create(:user, id: 1, name: "Foo")
    FactoryGirl.create(:user, id: 2, name: "Bar")
  end

  before :each do
    Pour.delete_all
  end

  describe 'calculates metrics with appropriate options' do
    before do
      FactoryGirl.create(:pour, user_id: 0, keg_id: 1, volume: 0)
      FactoryGirl.create(:pour, user_id: 1, keg_id: 1, volume: 12)
      FactoryGirl.create(:pour, user_id: 2, keg_id: 1, volume: 23, created_at: Time.now - 31.days, finished_at: Time.now - 31.days)
      FactoryGirl.create(:pour, user_id: 1, keg_id: 1, volume: 999, created_at: Time.now - 5.seconds, finished_at: nil)
      FactoryGirl.create(:pour, user_id: 0, keg_id: 2, volume: 999)
      FactoryGirl.create(:pour, user_id: 1, keg_id: 2, volume: 34)
      FactoryGirl.create(:pour, user_id: 2, keg_id: 2, volume: 45, created_at: Time.now - 31.days, finished_at: Time.now - 31.days)
    end

    it 'ignores pours for Guests' do
      expect(Achievement.calculate({ metric: "sum(volume)",
                                       name: "Foo",
                                description: "Bar",
                                    reverse: true, # needed to reverse results to get max value since first result is always used
                                     keg_id: 2 }).value.to_d).to eq(45.to_d)
    end

    it 'ignores pours that haven\'t finished' do
      expect(Achievement.calculate({ metric: "sum(volume)",
                                       name: "Foo",
                                description: "Bar",
                                    reverse: true,
                                     keg_id: 1 }).value.to_d).to eq(23.to_d)
    end

    it 'calculates metrics for all pours' do
      expect(Achievement.calculate({ metric: "sum(volume)",
                                       name: "Foo",
                                description: "Bar",
                                    reverse: true,
                                    reverse: true }).value.to_d).to eq(68.to_d)
    end

    it 'limits calculation by a keg' do
      expect(Achievement.calculate({ metric: "sum(volume)",
                                       name: "Foo",
                                description: "Bar",
                                    reverse: true,
                                     keg_id: 1}).value.to_d).to eq(23.to_d)
    end

    it 'limits calculation by a time period' do
      expect(Achievement.calculate({ metric: "sum(volume)",
                                       name: "Foo",
                                description: "Bar",
                                    reverse: true,
                                    time_gt: Time.now - 30.days }).value.to_d).to eq(46.to_d)
    end

    it 'limits calculation by multiple options' do
      expect(Achievement.calculate({ metric: "sum(volume)",
                                       name: "Foo",
                                description: "Bar",
                                    reverse: true,
                                     keg_id: 1,
                                    time_gt: Time.now - 30.days }).value.to_d).to eq(12.to_d)
    end
  end

  describe 'calculates total ounces poured' do
    before do
      FactoryGirl.create(:pour, user_id: 1, volume: 12)
      FactoryGirl.create(:pour, user_id: 1, volume: 34)
      FactoryGirl.create(:pour, user_id: 2, volume: 23)
      FactoryGirl.create(:pour, user_id: 2, volume: 45)
    end

    it 'calculates maximum volume by user' do
      expect(Achievement.total_poured_max.value.to_d).to eq(68.to_d)
    end

    it 'identifies user for maximum volume' do
      expect(Achievement.total_poured_max.user_name).to eq("Bar")
    end

    it 'calculates minimum volume by user' do
      expect(Achievement.total_poured_min.value.to_d).to eq(46.to_d)
    end

    it 'identifies user for minimum volume' do
      expect(Achievement.total_poured_min.user_name).to eq("Foo")
    end
  end

  describe 'calculates single pour volume' do
    before do
      FactoryGirl.create(:pour, user_id: 1, volume: 12)
      FactoryGirl.create(:pour, user_id: 1, volume: 34)
      FactoryGirl.create(:pour, user_id: 2, volume: 23)
      FactoryGirl.create(:pour, user_id: 2, volume: 45)
    end

    it 'calculates maximum pour by user' do
      expect(Achievement.single_pour_max.value.to_d).to eq(45.to_d)
    end

    it 'identifies user for maximum pour' do
      expect(Achievement.single_pour_max.user_name).to eq("Bar")
    end

    it 'calculates minimum pour by user' do
      expect(Achievement.single_pour_min.value.to_d).to eq(12.to_d)
    end

    it 'identifies user for minimum pour' do
      expect(Achievement.single_pour_min.user_name).to eq("Foo")
    end
  end

  describe 'calculates number of pours' do
    before do
      FactoryGirl.create_list(:pour, 3, { user_id: 1 })
      FactoryGirl.create_list(:pour, 2, { user_id: 2 })
    end

    it 'calculates maximum pour count by user' do
      expect(Achievement.total_pours_max.value.to_i).to eq(3)
    end

    it 'identifies user for maximum pour count' do
      expect(Achievement.total_pours_max.user_name).to eq("Foo")
    end

    it 'calculates minimum pour count by user' do
      expect(Achievement.total_pours_min.value.to_i).to eq(2)
    end

    it 'identifies user for minimum pour count' do
      expect(Achievement.total_pours_min.user_name).to eq("Bar")
    end
  end

  describe 'calculates pour duration' do
    before do
      FactoryGirl.create(:pour, user_id: 1, created_at: Time.now - 10.seconds, finished_at: Time.now)
      FactoryGirl.create(:pour, user_id: 2, created_at: Time.now - 10.minutes, finished_at: Time.now)
      FactoryGirl.create(:pour, user_id: 2, created_at: Time.now, finished_at: Time.now)
    end

    it 'calculates maximum pour duration by user' do
      pending "need to reconcile timestamp differences"
      expect(Achievement.pour_time_max.value).to eq(600.seconds)
    end

    it 'identifies user for maximum pour duration' do
      pending "need to reconcile timestamp differences"
      expect(Achievement.pour_time_max.user_name).to eq("Bar")
    end

    it 'calculates minimum pour duration by user' do
      pending "need to reconcile timestamp differences"
      expect(Achievement.pour_time_min.value).to eq(10.seconds)
    end

    it 'identifies user for minimum pour duration' do
      pending "need to reconcile timestamp differences"
      expect(Achievement.pour_time_min.user_name).to eq("Foo")
    end
  end
end
