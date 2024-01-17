module Hubot
  def self.send_message(message)
    return false if hubot_url.blank?

    uri = URI.parse(Setting.hubot_url)
    req = Net::HTTP::Post.new(uri.path)
    req["Content-Type"] = "application/json"
    req.body = {data: message}.to_json

    begin
      Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
    rescue => e
      puts "Encountered #{e.message} (#{e.class}) while trying to report to rosie" # standard:disable Rails/Output
    end
  end

  def self.hubot_url
    ENV["HUBOT_URL"]
  end
end
