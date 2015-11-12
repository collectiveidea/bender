require 'spec_helper'

describe Kegerator do
  before(:each) do
    @temp_sensor = FactoryGirl.create(:temperature_sensor, name: 'Kegerator', code: '43212')
    @kegerator   = FactoryGirl.create(:kegerator, temperature_sensor: @temp_sensor)
  end

  describe '#cooling?' do
    it 'returns false if the most recent temp is the highest' do
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 46, created_at: 1.minute.ago)
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 45, created_at: 15.minutes.ago)
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 47, created_at: 31.minutes.ago) # beyond time limit

      expect(@kegerator).not_to be_cooling
    end

    it 'returns true if there was a recent higher temp' do
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 44, created_at: 1.minute.ago)
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 46, created_at: 15.minutes.ago)

      expect(@kegerator).to be_cooling
    end
  end

  describe '#send_alarm_message' do
    before(:each) do
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 44, created_at: 31.minutes.ago)
      GPIO::Pin.stub(:new).and_return(double(on: true, off: true))
    end

    it 'sends an alarm message when we are at the correct time interval' do
      reading = FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 49)

      Hubot.should_receive(:send_message).with("ALERT: The kegerator temperature is at 49.0")

      @kegerator.send_alarm_message(reading)
    end

    it 'does not send a message if we are outside the correct time interval' do
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 44, created_at: 30.minutes.ago)

      reading = FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 49)

      Hubot.should_not_receive(:send_message)

      @kegerator.send_alarm_message(reading)
    end

    # currently disabled
    xit 'does not send an alarm message when we are cooling' do
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 50, created_at: 25.minutes.ago)

      reading = FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 49)

      Hubot.should_not_receive(:send_message)

      @kegerator.send_alarm_message(reading)
    end
  end

  describe '#send_all_clear_message' do
    before(:each) do
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 49, created_at: 31.minutes.ago)
    end

    it 'sends the message on the first reading below the alarm temp' do
      reading = FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 47)

      Hubot.should_receive(:send_message).with("All Clear: The kegerator is now below the alarm temperature")

      @kegerator.send_all_clear_message(reading)
    end

    it 'does not send the message on the later readings below the alarm temp' do
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 47, created_at: 2.minutes.ago)
      reading = FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 47)

      Hubot.should_not_receive(:send_message)

      @kegerator.send_all_clear_message(reading)
    end
  end

  describe '#report_dms' do
    before(:each) do
      Setting.stub(:dms_url).and_return('https://nosnch.in/66860019c9')
    end

    it 'pings DMS if everything is good' do
      reading = FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 43)

      Net::HTTP.should_receive(:start)

      @kegerator.report_dms(reading)
    end

    it 'does not ping DMS if we are above the alarm temp' do
      reading = FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 50)

      Net::HTTP.should_not_receive(:start)

      @kegerator.report_dms(reading)
    end

    # currently disabled
    xit 'pings DMS if we are above the alarm temp and cooling' do
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 52, created_at: 2.minutes.ago)
      reading = FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 50)

      Net::HTTP.should_receive(:start)

      @kegerator.report_dms(reading)
    end
  end
end
