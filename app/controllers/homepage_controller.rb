class HomepageController < ApplicationController
  def index
    @beer_taps = BeerTap.all
    @pours = Pour.order('created_at desc').limit(@beer_taps.size * 4)
  end
end
