local gimlet_dispatch

if ngx
	gimlet_dispatch = require "gimlet.backend.nginx"
else
	gimlet_dispatch = require "gimlet.backend.wsapi"

gimlet_dispatch
