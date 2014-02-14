class User < ActiveRecord::Base
  validates :name, :uniqueness => true

  def self.guest
    find_by(id: 0) || new(id: 0)
  end

  def last_pour_at
    Pour.where('volume IS NOT NULL AND user_id = ?', self.id).maximum(:created_at)
  end

  def gravatar_url(opts = {})
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.to_s.downcase.strip)}?s=#{opts[:size] || 50}&d=retro"
  end
end
