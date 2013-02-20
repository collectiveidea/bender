class HomepageController < ApplicationController
  def index
    @beer_taps = BeerTap.all
  end
end
