module API
  module V1
    class PoursController < ApplicationController
      def index
        @pours = Pour.for_listing.except(:includes)
          .between_dates(start_time: start_time, end_time: end_time)

        render json: Oj.dump(@pours.as_json(except: [:sensor_ticks, :updated_at]), mode: :compat)
      end

      def show
        pours = Pour.between_dates(start_time: start_time, end_time: end_time)
        case params[:id]
        when "by_beer"
          data = pours.joins(:keg).where.not(started_at: nil)
            .group("kegs.name, pour_date").order("kegs.name, pour_date")
            .pluck(Arel.sql("kegs.name AS name, date_trunc('day', pours.started_at::TIMESTAMPTZ AT TIME ZONE '#{Time.zone.tzinfo.canonical_identifier}') AS pour_date, count(pours.id) AS pour_count"))
            .each.with_object({}) do |pour, out|
              (out[pour[0]] ||= []) << [pour[1].to_date, pour[2]]
            end

          render json: Oj.dump(data.as_json, mode: :compat)
        when "by_user"
          data = pours.joins(:user)
            .group("users.name, users.email").select("users.name", "users.email, SUM(pours.volume) AS volume")
          render json: Oj.dump(data.as_json, mode: :compat)
        end
      end

      def create
        user = User.where("id = ? OR rfid = ?", params[:user_id], params[:user_rfid]).first! if params[:user_id] != "0"
        unless user.pours_remaining?
          render status: :forbidden, plain: "Insufficient credits remaining"
          return
        end

        tap = BeerTap.find(params[:beer_tap_id])
        pour = tap.active_keg.start_pour(user)

        if pour.persisted?
          render json: Oj.dump(pour.as_json, mode: :compat), status: :created
        else
          render json: Oj.dump(pour.errors.to_json, mode: :compat), status: :unprocessible_entity
        end
      end

      private

      def start_time
        if params[:start_time]
          Time.zone.parse(params[:start_time])
        end
      end

      def end_time
        if params[:end_time]
          Time.zone.parse(params[:end_time])
        end
      end
    end
  end
end
