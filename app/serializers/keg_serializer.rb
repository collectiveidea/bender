class KegSerializer < ActiveModel::Serializer
  attributes :id, :beer_tap_id, :name, :description, :active, :capacity, :started_at, :finished_at

  def attributes
    data = super
    data[:poured] = object.poured
    data[:remaining] = object.remaining
    data[:projected_empty] = object.projected_empty
    data
  end
end
