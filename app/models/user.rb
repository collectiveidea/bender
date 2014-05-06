class User < ActiveRecord::Base
  validates :name, uniqueness: true

  def self.guest
    find_by(id: 0) || new(id: 0, name: 'Guest')
  end

  def last_pour_at
    Pour.where('volume IS NOT NULL AND user_id = ?', id).maximum(:created_at).try(:in_time_zone)
  end

  def gravatar_url(opts={})
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest((email || name).downcase.strip)}?s=#{opts[:size] || 50}&d=retro"
  end
end
