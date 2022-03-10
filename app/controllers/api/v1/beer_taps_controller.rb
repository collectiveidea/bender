module API
  module V1
    class BeerTapsController < APIController
      def index
        beer_taps = BeerTap.preload(:active_keg).order(:display_order)

        render json: Oj.dump(beer_taps.as_json(only: [:id, :name, :display_order], include: [:active_keg]), mode: :compat)
      end
    end
  end
end
