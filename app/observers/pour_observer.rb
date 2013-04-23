require 'net/http'

class PourObserver < ActiveRecord::Observer
  observe :pour

  def after_create(pour)
    send_pour_update(pour)
  end

  def after_update(pour)
    send_pour_update(pour)
    send_to_campfire(pour)
  end

  def send_pour_update(pour)
    return true if Setting.faye_url.blank? || pour.volume.to_f <= 0.1 || pour.complete?

    update_type = (pour.finished_at ? :complete : :update)

    uri  = URI.parse(Setting.faye_url)
    data = pour.attributes.symbolize_keys
    data[:beer_tap_id] = pour.keg.beer_tap_id.to_s
    message = {channel: "/pour/#{update_type}", data: data}

    begin
      Net::HTTP.post_form(uri, :message => message.to_json)
    rescue StandardError => e
      puts "Encountered #{e.message} (#{e.class}) while trying to connect to faye"
    end
  end

  def send_to_campfire(pour)
    return true if Setting.hubot_url.blank? || pour.finished_at.blank?

    if pour.user_id == 0
      Hubot.send_message("Someone just poured a %0.1foz %s." % [pour.volume, pour.keg.name])
    elsif pour.user_id_change && pour.user_id_change[0] == 0
      Hubot.send_message("%s has claimed the %0.1foz pour." % [pour.user.name, pour.volume])
    end
  end
end
