class User < ActiveRecord::Base
  attr_accessible :name, :email

  validates :name, :uniqueness => true
  
  def last_pour_at
    Pour.where('volume IS NOT NULL AND user_id = ?', self.id).maximum(:created_at)
  end
end
