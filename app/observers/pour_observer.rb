require "net/http"

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

    data = {
      id: pour.id,
      volume: pour.volume,
      beer_tap_id: pour.keg.beer_tap_id.to_s
    }

    FayeNotifier.send_message("/pour/#{update_type}", data)
  end

  def send_to_campfire(pour)
    return true if pour.finished_at.blank?

    if pour.user_id == 0
      Hubot.send_message("Someone just poured a %0.1foz %s." % [pour.volume, pour.keg.name])
    elsif pour.previous_changes[:user_id] && pour.previous_changes[:user_id][0] == 0
      Hubot.send_message("%s has claimed the %0.1foz pour." % [pour.user.name, pour.volume])
    end
  end

  def decrement_user_credits(pour)
    if pour.previous_changes[:user_id] && pour.previous_changes[:volume]&.first && pour.previous_changes[:volume].first > 0
      User.find(pour.previous_changes[:user_id].first).increment_credits(pour.previous_changes[:volume].first)
      pour.user.decrement_credits(pour.previous_changes[:volume].first)
    end
    if pour.previous_changes[:volume]
      change = pour.volume
      change -= pour.previous_changes[:volume].first if pour.previous_changes[:volume].first
      pour.user.decrement_credits(change)
    end
  end
end
