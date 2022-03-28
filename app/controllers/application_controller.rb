class ApplicationController < ActionController::Base
  include Pagy::Backend

  def default_serializer_options
    {root: false}
  end
end
