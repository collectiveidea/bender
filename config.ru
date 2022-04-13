# This file is used by Rack-based servers to start the application.

require ::File.expand_path("../config/environment", __FILE__)

require "faye"
Faye::WebSocket.load_adapter("puma")
use Faye::RackAdapter, mount: "/faye", timeout: 30, ping: 1

run Bender::Application
