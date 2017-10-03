class User < ActiveRecord::Base
  validates :name, uniqueness: true

  has_many :pours

  def self.guest
    find_by(id: 0) || new(id: 0, name: 'Guest')
  end

  def first_pour_at
    pours.finished.minimum(:created_at).try(:in_time_zone)
  end

  def stats
    data = attributes.slice("name", "created_at", "email", "id")
    data["gravatar"] = gravatar_base_url
    data["first_pour_at"] = first_pour_at
    data["last_pour_at"] = last_pour_at
    data["recent_pour_count"] = pours.finished.recent.count
    data["pour_count_by_volume"] = pours.finished.recent.group("amount").order("amount").pluck("round(volume) AS amount", "count(id)")
    data["recent_pours"] = pours.finished.recent.order(finished_at: :desc).pluck("volume", "started_at")
    data
  end

  def gravatar_url(opts={})
    "#{gravatar_base_url}&s=#{opts[:size] || 50}"
  end

  def gravatar_base_url
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest((email || name).downcase.strip)}?d=retro"
  end

  def decrement_credits(volume)
    if credits.present?
      update(credits: [credits - volume, 0].max)
    end
  end

  def increment_credits(volume)
    if credits.present?
      update(credits: credits + volume)
    end
  end

  def pours_remaining?
    credits.nil? || credits > 0
  end
end
