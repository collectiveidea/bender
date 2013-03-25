module Hubot
  def self.send_message(message)
    return false if Setting.hubot_url.blank?

    uri = URI.parse(Setting.hubot_url)
    req = Net::HTTP::Post.new(uri.path)
    req["Content-Type"] = "application/json"
    req.body = {data: message}.to_json

    begin
      Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
    rescue StandardError => e
      puts "Encountered #{e.message} (#{e.class}) while trying to report to rosie"
    end
  end
end