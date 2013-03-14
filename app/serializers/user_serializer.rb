class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email

  def attributes
    data = super
    data[:last_pour_at] = object.last_pour_at
    data
  end
end
