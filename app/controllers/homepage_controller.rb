class HomepageController < ApplicationController
  def index
    @beer_taps = BeerTap.order(:display_order)
    @pours = Pour.where.not(volume: nil).order("created_at desc").limit(@beer_taps.size * 3)
  end
end
