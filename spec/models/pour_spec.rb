require 'spec_helper'

describe Pour do
  describe "#complete?" do
    before :each do
      Timecop.freeze(Time.current)
    end

    after do
      Timecop.return
    end

    it 'returns true if the pour is completed and the current time is after the pour timeout' do
      pour = FactoryGirl.create(:pour, finished_at: Time.current)
      Timecop.travel(Time.current + Setting.pour_timeout + 1)
      expect(pour.complete?).to eq(true)
    end

    it 'returns false if the pour is completed and the current time is within the pour timeout' do
      pour = FactoryGirl.create(:pour, finished_at: Time.current)
      expect(pour.complete?).to eq(false)
    end
  end
end
