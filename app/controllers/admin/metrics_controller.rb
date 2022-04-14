class Admin::MetricsController < Admin::ApplicationController
  def achievements
    render json: Achievement.all.to_json
  end
end
