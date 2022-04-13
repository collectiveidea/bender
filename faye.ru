require "faye"
Faye::WebSocket.load_adapter("puma")
faye_server = Faye::RackAdapter.new(mount: "/faye", timeout: 30, ping: 1)
run faye_server
