module Setting
  def self.hubot_url
    settings['hubot_url']
  end

  def self.faye_url
  	settings['faye_url']
  end

  def self.pour_timeout
  	settings['pour_timeout']
  end

  def self.settings
    @settings ||= YAML.load_file(Rails.root.join('config','settings.yml'))
  end
end