class TemperatureSensorsController < ApplicationController
  def readings
    sensor = TemperatureSensor.find(params[:sensor_id])
    start_time = Time.at(params[:start_timestamp].to_i)
    end_time   = start_time + params[:duration].to_i

    render :json => sensor.temp_data(start_time, end_time)
    cache_page if end_time < Time.now
  end
end
