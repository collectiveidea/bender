class Admin::SettingsController < ApplicationController
  def index
    @settings = Setting.settings
  end
end
