class User < ActiveRecord::Base
  validates :name, uniqueness: true

  has_many :pours

  def self.guest
    find_by(id: 0) || new(id: 0, name: 'Guest')
  end

  def first_pour_at
    pours.finished.minimum(:created_at).try(:in_time_zone)
  end

  def last_pour_at
    pours.finished.maximum(:created_at).try(:in_time_zone)
  end

  def stats
    data = attributes.slice("name", "created_at", "email")
    data["gravatar"] = gravatar_base_url
    data["first_pour_at"] = first_pour_at
    data["last_pour_at"] = last_pour_at
    data["recent_pour_count"] = pours.finished.recent.count
    data["pour_count_by_volume"] = pours.finished.recent.group("amount").order("amount").pluck("round(volume) AS amount", "count(id)")
    data
  end

  def gravatar_url(opts={})
    "#{gravatar_base_url}&s=#{opts[:size] || 50}"
  end

  def gravatar_base_url
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest((email || name).downcase.strip)}?d=retro"
  end
end
