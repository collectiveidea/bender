class AdminController < ApplicationController
  http_basic_authenticate_with name: "bender", password: Setting.admin_password, if: :needs_authetication?

  private

  def needs_authetication?
    Setting.admin_password.present?
  end
end
