class Admin::ApplicationController < ::ApplicationController
  http_basic_authenticate_with name: "bender", password: ENV["ADMIN_PASSWORD"], if: :needs_authetication?

  private

  def needs_authetication?
    ENV["ADMIN_PASSWORD"].present?
  end
end
