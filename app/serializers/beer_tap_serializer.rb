class BeerTapSerializer < ActiveModel::Serializer
  attributes :id, :name, :gpio_pin, :created_at, :updated_at, :temperature_sensor_id, :ml_per_tick, :kegerator_id, :display_order

  has_one :active_keg, serializer: SimpleKegSerializer
end
