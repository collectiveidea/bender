class ApplicationController < ActionController::Base
  def default_serializer_options
    {root: false}
  end
end
