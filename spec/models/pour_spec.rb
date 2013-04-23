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

    describe 'hubot communication' do
      before(:each) do
        Setting.stub(:hubot_url).and_return('Not Blank')
      end

      it 'sends a hubot message on completing an anonymous pour' do
        pour = FactoryGirl.create(:pour, user_id: 0, finished_at: nil, volume: "12")

        Hubot.should_receive(:send_message).with("Someone just poured a 12.0oz #{pour.keg.name}.")

        pour.finished_at = Time.now
        pour.save
      end

      it 'sends a hubot message on claiming an anonymous pour' do
        pour = FactoryGirl.create(:pour, user_id: 0, finished_at: Time.current, volume: "12")
        user = FactoryGirl.create(:user, name: 'Jim')

        Hubot.should_receive(:send_message).with("Jim has claimed the 12.0oz pour.")

        pour.user = user
        pour.save
      end
    end
  end
end
