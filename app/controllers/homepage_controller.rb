class HomepageController < ApplicationController
  def index
    @beer_taps = BeerTap.all
  end

  def temp_data
    data = TemperatureSensor.all.map {|ts| {name: ts.name, data: ts.temp_data} }
    render :json => data
  end
end
