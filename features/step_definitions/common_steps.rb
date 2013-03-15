When "I debug" do
  debugger
end

When "I refresh" do
  visit URI.parse(current_url).path
end
