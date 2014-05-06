class ApplicationController < ActionController::Base
  protect_from_forgery

  def default_serializer_options
    {root: false}
  end
end
