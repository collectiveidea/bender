class PourObserver < ActiveRecord::Observer
	attr_accessor :faye_client
  observe :pour

  def after_update(pour)
  	puts "Pour update"
    message = {channel: "/testing", data: {type: "pour_volume", tap_id: pour.keg.beer_tap.id, volume: pour.volume.to_s}}
    uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end
end
