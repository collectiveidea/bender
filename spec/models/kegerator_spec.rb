require 'spec_helper'

describe Kegerator do
  describe '#cooling?' do
    before(:each) do
      @temp_sensor = FactoryGirl.create(:temperature_sensor, name: 'Kegerator', code: '43212')
      @kegerator   = FactoryGirl.create(:kegerator, temperature_sensor: @temp_sensor)
    end

    it 'returns false if the most recent temp is the highest' do
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 46, created_at: 1.minute.ago)
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 45, created_at: 15.minutes.ago)
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 47, created_at: 31.minutes.ago) # beyond time limit

      expect(@kegerator.cooling?).to be_false
    end

    it 'returns true if there was a recent higher temp' do
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 44, created_at: 1.minute.ago)
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 46, created_at: 15.minutes.ago)

      expect(@kegerator.cooling?).to be_true
    end
  end

  describe '#send_alarm_message' do
    before(:each) do
      @temp_sensor = FactoryGirl.create(:temperature_sensor, name: 'Kegerator', code: '43212')
      @kegerator   = FactoryGirl.create(:kegerator, temperature_sensor: @temp_sensor)

      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 44, created_at: 31.minutes.ago)
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

    it 'does not send an alarm message when we are cooling' do
      FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 50, created_at: 25.minutes.ago)

      reading = FactoryGirl.create(:temperature_reading, temperature_sensor: @temp_sensor, temp_f: 49)

      Hubot.should_not_receive(:send_message)

      @kegerator.send_alarm_message(reading)
    end
  end
end
