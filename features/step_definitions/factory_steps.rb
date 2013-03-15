Given "a beer tap" do
  FactoryGirl.create(:beer_tap)
end

Given /^a keg on this beer tap with name "(.*?)"$/ do |name|
  tap = BeerTap.order("id desc").first
  keg = FactoryGirl.create(:keg, {name: name})
  keg.tap_it(tap.id)
end

Given /^([a-z ]+) pours a ([0-9\.]+) oz ([a-z ]+)$/i do |user_name, volume, beer_name|
  keg = Keg.where(name: beer_name).first || raise("Keg not found")
  user = User.where(name: user_name).first || FactoryGirl.create(:user, name: user_name)
  FactoryGirl.create(:pour, keg_id: keg.id, user_id: user.id, volume: volume)
end
