require "rails_helper"

describe Pour do
  include ActiveSupport::Testing::TimeHelpers

  let!(:guest) { User.create(id: 0, name: "Guest") }
  describe "#complete?" do
    before :each do
      freeze_time
    end

    after do
      travel_back
    end

    it 'returns true if the pour is completed and the current time is after the pour timeout' do
      pour = FactoryBot.create(:pour, finished_at: Time.current)
      travel_to(Time.current + Setting.pour_timeout + 1)
      expect(pour.complete?).to eq(true)
    end

    it 'returns false if the pour is completed and the current time is within the pour timeout' do
      pour = FactoryBot.create(:pour, finished_at: Time.current)
      expect(pour.complete?).to eq(false)
    end

    describe 'hubot communication' do
      before(:each) do
        allow(Setting).to receive(:hubot_url).and_return('Not Blank')
      end

      it 'sends a hubot message on completing an anonymous pour' do
        pour = FactoryBot.create(:pour, user_id: 0, finished_at: nil, volume: "12")

        expect(Hubot).to receive(:send_message).with("Someone just poured a 12.0oz #{pour.keg.name}.")

        pour.finished_at = Time.now
        pour.save
      end

      it 'sends a hubot message on claiming an anonymous pour' do
        pour = FactoryBot.create(:pour, user_id: 0, finished_at: Time.current, volume: "12")
        user = FactoryBot.create(:user, name: 'Jim')

        expect(Hubot).to receive(:send_message).with("Jim has claimed the 12.0oz pour.")

        pour.user = user
        pour.save
      end
    end
  end

  describe "#between_dates" do
    let(:start_datetime) { 3.weeks.ago }
    let(:end_datetime) { 1.weeks.ago }

    let!(:pour1) { FactoryBot.create(:pour, created_at: start_datetime) }
    let!(:pour2) { FactoryBot.create(:pour, created_at: end_datetime) }
    let!(:empty_volume) { FactoryBot.create(:pour, volume: nil) }

    context "when no dates are given" do
      it "returns all listable pours" do
        result = Pour.between_dates(start_time: nil, end_time: nil)

        expect(result.size).to eql(3)
        expect(result).to include(pour1, pour2)
      end
    end

    context "dates are given" do
      it "returns pours that were created between the dates" do
        result = Pour.between_dates(start_time: start_datetime, end_time: end_datetime)

        expect(result.size).to eql(2)
        expect(result).to include(pour1, pour2)

        result = Pour.between_dates(start_time: start_datetime, end_time: 2.weeks.ago)

        expect(result.size).to eql(1)
        expect(result).to include(pour1)
      end
    end
  end
end
