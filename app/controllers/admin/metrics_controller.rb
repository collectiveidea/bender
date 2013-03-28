class Admin::MetricsController < ApplicationController
  respond_to :json

  def achievements
    respond_with Achievement.all
  end
end
