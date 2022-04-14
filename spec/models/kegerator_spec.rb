require "rails_helper"

describe Kegerator do
  before do
    allow(FayeNotifier).to receive(:send_message).and_return(true)
    @temp_sensor = FactoryBot.create(:temperature_sensor, name: "Kegerator", code: "43212")
    @kegerator = FactoryBot.create(:kegerator, temperature_sensor: @temp_sensor)
  end

  describe "#cooling?" do
    it "returns false if the most recent temp is the highest" do
      FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 46, created_at: 1.minute.ago)
      FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 45, created_at: 15.minutes.ago)
      FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 47, created_at: 31.minutes.ago) # beyond time limit

      expect(@kegerator).not_to be_cooling
    end

    it "returns true if there was a recent higher temp" do
      FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 44, created_at: 1.minute.ago)
      FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 46, created_at: 15.minutes.ago)

      expect(@kegerator).to be_cooling
    end
  end

  describe "#send_alarm_message" do
    before(:each) do
      FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 44, created_at: 31.minutes.ago)
      allow(GPIO::Pin).to receive(:new).and_return(double(on: true, off: true))
    end

    it "sends an alarm message when we are at the correct time interval" do
      reading = FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 49)

      expect(Hubot).to receive(:send_message).with("ALERT: The kegerator temperature is at 49.0")

      @kegerator.send_alarm_message(reading)
    end

    it "does not send a message if we are outside the correct time interval" do
      FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 44, created_at: 30.minutes.ago)

      reading = FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 49)

      expect(Hubot).not_to receive(:send_message)

      @kegerator.send_alarm_message(reading)
    end

    # currently disabled
    xit "does not send an alarm message when we are cooling" do
      FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 50, created_at: 25.minutes.ago)

      reading = FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 49)

      expect(Hubot).not_to receive(:send_message)

      @kegerator.send_alarm_message(reading)
    end
  end

  describe "#send_all_clear_message" do
    before(:each) do
      FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 49, created_at: 31.minutes.ago)
    end

    it "sends the message on the first reading below the alarm temp" do
      reading = FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 47)

      expect(Hubot).to receive(:send_message).with("All Clear: The kegerator is now below the alarm temperature")

      @kegerator.send_all_clear_message(reading)
    end

    it "does not send the message on the later readings below the alarm temp" do
      FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 47, created_at: 2.minutes.ago)
      reading = FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 47)

      expect(Hubot).not_to receive(:send_message)

      @kegerator.send_all_clear_message(reading)
    end
  end

  describe "#report_dms" do
    before(:each) do
      allow(Kegerator).to receive(:dms_url).and_return("https://nosnch.in/66860019c9")
    end

    it "pings DMS if everything is good" do
      reading = FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 43)

      expect(Net::HTTP).to receive(:start)

      @kegerator.report_dms(reading)
    end

    it "does not ping DMS if we are above the alarm temp" do
      reading = FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 50)

      expect(Net::HTTP).not_to receive(:start)

      @kegerator.report_dms(reading)
    end

    # currently disabled
    xit "pings DMS if we are above the alarm temp and cooling" do
      FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 52, created_at: 2.minutes.ago)
      reading = FactoryBot.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 50)

      expect(Net::HTTP).not_to receive(:start)

      @kegerator.report_dms(reading)
    end
  end
end
