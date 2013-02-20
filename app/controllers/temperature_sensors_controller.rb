class TemperatureSensorsController < ApplicationController
  def show
    sensor = TemperatureSensor.find(params[:id])
    start_time = Time.parse(params[:start_time]) rescue 24.hours.ago
    end_time   = Time.parse(params[:end_time])   rescue Time.now
    render :json => sensor.temp_data(start_time, end_time)
  end
end
