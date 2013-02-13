module Setting
  def self.hubot_url
    settings['hubot_url']
  end

  def self.settings
    @settings ||= YAML.load_file(Rails.root.join('config','settings.yml'))
  end
end