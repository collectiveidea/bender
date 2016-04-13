class SimpleKegSerializer < ActiveModel::Serializer
  attributes :id, :beer_tap_id, :name, :brewery, :style, :abv, :description, :active, :capacity, :started_at, :finished_at, :poured, :remaining, :projected_empty
end
