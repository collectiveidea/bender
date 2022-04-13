class ActivityController < ApplicationController
  def recent
    pours = Pour.where("volume IS NOT NULL").order("created_at desc").limit(params[:limit] || 10)

    render json: append_data(pours).to_json
  end

  def user_recent
    pours = Pour.where("volume IS NOT NULL AND user_id = ?", params[:user_id]).order("created_at desc").limit(params[:limit] || 10)

    render json: append_data(pours).to_json
  end

  def append_data(pours)
    pours.each_with_index do |pour, index|
      pours[index][:user_name] = pour.user.name
      pours[index][:beer_name] = pour.keg.name
    end

    pours
  end
end
