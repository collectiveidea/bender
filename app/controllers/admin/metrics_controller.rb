class Admin::MetricsController < ApplicationController
  def achievements
    render json: Achievement.all.to_json
  end
end
