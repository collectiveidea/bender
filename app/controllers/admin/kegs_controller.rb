class Admin::KegsController < ApplicationController
  respond_to :html, :json

  def index
    @kegs = Keg.all
    respond_with @kegs
  end

  def show
    @keg = Keg.find(params[:id])
    respond_with @keg
  end

  def new
    @keg = Keg.new
    respond_with @keg
  end

  def create
    @keg = Keg.new(params[:keg])
    if @keg.save
      redirect_to [:admin, @keg]
    else
      render :new
    end
  end

  def edit
    @keg = Keg.find(params[:id])
    respond_with @keg
  end

  def update
    @keg = Keg.find(params[:id])
    if @keg.update_attributes(params[:keg])
      redirect_to [:admin, @keg]
    else
      render :edit
    end
  end

  def list_taps
    @keg = Keg.find(params[:keg_id])
    @beer_taps = BeerTap.for_select
  end

  def tap_keg
    @keg = Keg.find(params[:keg_id])
    if @keg.tap_it(params[:keg].try(:[], :beer_tap_id))
      redirect_to [:admin, @keg]
    else
      @beer_taps = BeerTap.for_select
      render :list_taps
    end
  end

  def untap_keg
    @keg = Keg.find(params[:keg_id])
    @keg.untap_it
    redirect_to [:admin, @keg]
  end

end
