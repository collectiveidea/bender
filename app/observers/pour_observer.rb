class PourObserver < ActiveRecord::Observer
  observe :pour

  def after_update(pour)
    send_pour_update(pour)
    send_to_campfire(pour)
  end

  def send_pour_update(pour)
    data = {}
    pour.attributes.each { |attribute, value| data[attribute.to_sym] = value.to_s } 
    data[:beer_tap_id] = pour.keg.beer_tap_id

    message = {channel: "/pour/update", data: data}
    uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
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
