module Setting
  def self.kegerator_name
    settings['kegerator_name']
  end

  def self.hubot_url
    settings['hubot_url']
  end

  def self.faye_url(substitue_host = nil)
    return nil unless settings['faye_url']
    if substitue_host
      uri = URI.parse(settings['faye_url'])
      uri.host = substitue_host
      uri.to_s
    else
      settings['faye_url']
    end
  end

  def self.pour_timeout
    settings['pour_timeout'] || 10
  end

  def self.dms_url
    settings['dms_url']
  end

  # This should be the path to the bin directory
  # not the actual binary
  # ex: /home/pi/mruby/bin
  def self.mruby_bin
    settings['mruby_bin']
  end

  def self.settings
    @settings ||= YAML.load_file(Rails.root.join('config', 'settings.yml'))
  end
end
