module Setting
  def self.faye_url(substitue_host = nil)
    return nil unless ENV["FAYE_URL"]
    if substitue_host
      uri = URI.parse(ENV["FAYE_URL"])
      uri.host = substitue_host
      uri.to_s
    else
      ENV["FAYE_URL"]
    end
  end

  def self.pour_timeout
    ENV.fetch("POUR_TIMEOUT", 10).to_i
  end
end
