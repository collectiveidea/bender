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
    Rails.logger.info "-- pour changes #{pour.changes}"

    if pour.changes.keys.include?("finished_at") && pour.user.present?
      Rails.logger.info "--- Pour updated user credits:"
      Rails.logger.info pour.inspect

      pour.user.decrement_credits(pour.volume)
    end
  end
end
