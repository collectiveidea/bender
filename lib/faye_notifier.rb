module FayeNotifier
  def self.configured?
    Setting.faye_url.present?
  end

  def self.send_message(channel, data)
    return unless configured?

    begin
      Net::HTTP.post_form(
        URI.parse(Setting.faye_url),
        message: {channel: channel, data: data}.to_json
      )
    rescue => e
      puts "Encountered #{e.message} (#{e.class}) while trying to connect to faye"
    end
  end
end
