class Admin::TemperatureSensorsController < Admin::ApplicationController
  def index
    @temperature_sensors = TemperatureSensor.order(:name)
  end

  def all_graphs
    @temperature_sensors = TemperatureSensor.order(:name)
  end

  def show
    @temperature_sensor = TemperatureSensor.find(params[:id])
  end

  def edit
    @temperature_sensor = TemperatureSensor.find(params[:id])
  end

  def update
    @temperature_sensor = TemperatureSensor.find(params[:id])
    if @temperature_sensor.update(temperature_sensor_params)
      redirect_to [:admin, @temperature_sensor]
    else
      render :edit
    end
  end

  protected

  def temperature_sensor_params
    params.require(:temperature_sensor).permit(:name)
  end
end
