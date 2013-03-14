class User < ActiveRecord::Base
  attr_accessible :name, :email
  attr_reader :last_pour_at

  validates :name, :uniqueness => true
  
  def last_pour_at
    pour = Pour.where('volume IS NOT NULL AND user_id = ?', self.id).order('created_at desc').first
    pour.nil? ? nil : pour.created_at
  end
end
