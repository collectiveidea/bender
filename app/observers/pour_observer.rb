require 'net/http'

class PourObserver < ActiveRecord::Observer
  observe :pour

  def after_create(pour)
    send_pour_update(pour, :create)
  end

  def after_update(pour)
    send_pour_update(pour)
    send_to_campfire(pour)
    decrement_user_credits(pour)
  end

  def send_pour_update(pour, update_type = nil)
    return true if !FayeNotifier.configured? || pour.volume.to_f <= 0.1

    update_type ||= (pour.finished_at ? :complete : :update)

    data = pour.attributes
    data['beer_tap_id'] = pour.keg.beer_tap_id.to_s

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

  def decrement_user_credits(pour)
    if pour.user_id_changed? && pour.volume_was && pour.volume_was > 0
      User.find(pour.user_id_was).increment_credits(pour.volume_was)
      pour.user.decrement_credits(pour.volume_was)
    end
    if pour.volume_changed?
      change = pour.volume
      change -= pour.volume_was if pour.volume_was
      pour.user.decrement_credits(change)
    end
  end
end
