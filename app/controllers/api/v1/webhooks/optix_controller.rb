module API
  module V1
    module Webhooks
      class OptixController < ApplicationController
        def create
          json = JSON.parse(request.raw_post)

          if json["checkin_id"]
            user = User.find_or_create_by!(email: json["member_email"])
            user.update!(name: json["member_full_name"]) if user.name.blank?
          elsif json["email"]
            User.find_or_create_by!(email: json["email"])
          end

          head :ok
        end
      end
    end
  end
end
