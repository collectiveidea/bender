class UserSerializer < ActiveModel::Serializer
  attributes :id, :rfid, :name, :email, :created_at

  def attributes
    data = super
    data[:last_pour_at] = object.last_pour_at
    data
  end
end
