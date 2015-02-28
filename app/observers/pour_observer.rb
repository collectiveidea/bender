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
    return true if !FayeNotifier.configured? || pour.volume.to_f <= 0.1 || pour.complete?

    update_type = (pour.finished_at ? :complete : :update)

    data = pour.attributes.symbolize_keys
    data[:beer_tap_id] = pour.keg.beer_tap_id.to_s

    FayeNotifier.send_message("/pour/#{update_type}", data)
  end

  def send_to_campfire(pour)
    return true if Setting.hubot_url.blank? || pour.finished_at.blank?

    if pour.user_id == 0
      Hubot.send_message('Someone just poured a %0.1foz %s.' % [pour.volume, pour.keg.name])
    elsif pour.user_id_change && pour.user_id_change[0] == 0
      Hubot.send_message('%s has claimed the %0.1foz pour.' % [pour.user.name, pour.volume])
    end
  end
end
