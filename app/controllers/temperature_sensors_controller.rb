class TemperatureSensorsController < ApplicationController
  def readings
    expires_now

    sensor = TemperatureSensor.find(params[:sensor_id])
    start_time = Time.at(params[:start_timestamp].to_i)
    end_time = start_time + params[:duration].to_i

    render json: Oj.dump(sensor.temp_data(start_time, end_time))
  end
end
