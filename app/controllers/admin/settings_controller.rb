class Admin::SettingsController < Admin::ApplicationController
  def index
    @settings = Setting.settings
  end
end
