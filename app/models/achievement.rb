class Achievement
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :description, :user_name, :value

  ACHIEVEMENTS = [:total_poured_max, :total_poured_min, :single_pour_max, :single_pour_min,
    :total_pours_max, :total_pours_min, :pour_time_max, :pour_time_min]

  def self.calculate(options = {})
    return unless [:metric, :name, :description].all? { |key| options.key?(key) }

    metric_summary = Pour.finished.non_guest.select("users.name as user_name, #{options[:metric]} as value")
      .group("users.name").order("value#{" desc" if options.fetch(:reverse, false)}").joins(:user)

    metric_summary = metric_summary.where("finished_at > ?", options[:time_gt]) if options.fetch(:time_gt, false)
    metric_summary = metric_summary.where("finished_at < ?", options[:time_lt]) if options.fetch(:time_lt, false)
    metric_summary = metric_summary.where(keg_id: options[:keg_id]) if options.fetch(:keg_id, false)

    metric = metric_summary.first

    if metric
      achievement = new(name: options[:name],
        description: options[:description],
        user_name: metric.user_name,
        value: metric.value)
    end

    achievement
  end

  # Collection
  # Accepts options:
  #   keg_id: ID of keg to filter achievements by
  #   time_gt: Time to filter history by (IE: Time.now - 30.days would be achievements for pours made in the last 30 days)
  #   time_lt: To be used with time_gt to specify a specific time period to calculate achievements for
  def self.all(options = {})
    return if options.any? { |key, value| ![:keg_id, :time_gt, :time_lt].include? key }

    achievements = []

    ACHIEVEMENTS.each do |achievement|
      result = class_eval("#{achievement}(#{options.inspect})", __FILE__, __LINE__)
      achievements << result if result
    end

    achievements
  end

  # Achievements

  def self.total_poured_max(options = {})
    options = {metric: "sum(volume)",
               reverse: true,
               name: "The Lush",
               description: "Most Total OZ Poured"}.merge(options)

    calculate(options)
  end

  def self.total_poured_min(options = {})
    options = {metric: "sum(volume)",
               reverse: false,
               name: "Designated Driver",
               description: "Least Total OZ Poured"}.merge(options)

    calculate(options)
  end

  def self.single_pour_max(options = {})
    options = {metric: "max(volume)",
               reverse: true,
               name: "Big Gulp",
               description: "Largest Single Pour"}.merge(options)

    calculate(options)
  end

  def self.single_pour_min(options = {})
    options = {metric: "min(volume)",
               reverse: false,
               name: "Little Dipper",
               description: "Smallest Single Pour"}.merge(options)

    calculate(options)
  end

  def self.total_pours_max(options = {})
    options = {metric: "count(pours.id)",
               reverse: true,
               name: "!!! Most Pours",
               description: "Most Total Pours"}.merge(options)

    calculate(options)
  end

  def self.total_pours_min(options = {})
    options = {metric: "count(pours.id)",
               reverse: false,
               name: "!!! Least Pours",
               description: "Least Total Pours"}.merge(options)

    calculate(options)
  end

  def self.pour_time_max(options = {})
    options = {metric: "max(duration)",
               reverse: true,
               name: "Long Winded",
               description: "Longest Single Pour"}.merge(options)

    calculate(options)
  end

  def self.pour_time_min(options = {})
    options = {metric: "min(duration)",
               reverse: false,
               name: "Quick Draw",
               description: "Shortest Single Pour"}.merge(options)

    calculate(options)
  end

  # Tableless foo

  def self.attr_accessor(*vars)
    @attributes ||= []
    @attributes.concat(vars)
    super
  end

  class << self
    attr_reader :attributes
  end

  def initialize(attributes = {})
    attributes && attributes.each do |name, value|
      send("#{name}=", value) if respond_to? name.to_sym
    end
  end

  def persisted?
    false
  end

  def self.inspect
    "#<#{self} #{attributes.map { |e| ":#{e}" }.join(", ")}>"
  end
end
