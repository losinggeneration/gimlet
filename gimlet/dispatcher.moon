-- We want this cached to avoid multiple hits to the dispatcher
gimlet_dispatch = nil

if ngx
	gimlet_dispatch = require "gimlet.backend.nginx"
else
	gimlet_dispatch = require "gimlet.backend.wsapi"

gimlet_dispatch
