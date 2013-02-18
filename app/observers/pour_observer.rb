class PourObserver < ActiveRecord::Observer
  observe :pour

  def after_create(pour)
    send_pour_update(pour, :start)
  end

  def after_update(pour)
    send_pour_update(pour, :update) unless pour.finished_at
    send_pour_update(pour, :complete) if pour.finished_at
    send_to_campfire(pour) if pour.finished_at
  end

  def send_pour_update(pour, update_type = :update)
    uri = URI.parse(Setting.faye_url)
    data = pour.attributes.symbolize!
    data[:beer_tap_id] = pour.keg.beer_tap_id.to_s

    message = case update_type
              when :start
                {channel: "/pour/start", data: data}
              when :update
                {channel: "/pour/update", data: data}
              when :complete
                {channel: "/pour/complete", data: data}
              end

    Net::HTTP.post_form(uri, :message => message.to_json) if message
  end

  def send_to_campfire(pour)
    return true if Setting.hubot_url.blank? || pour.finished_at.blank? || pour.user_id.present?

    uri = URI.parse(Setting.hubot_url)
    req = Net::HTTP::Post.new(uri.path)
    req["Content-Type"] = "application/json"
    req.body = {data: ("An anonymous coward just poured a %0.1foz %s." % [pour.volume, pour.keg.name])}.to_json

    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
  end
end
