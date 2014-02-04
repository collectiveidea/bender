class Admin::SettingsController < ApplicationController
  respond_to :json

  def index
    @settings = Setting.settings
    respond_with @settings
  end
end