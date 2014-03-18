-- We want this cached to avoid multiple hits to the dispatcher
export gimlet_dispatch = gimlet_dispatch or nil

return gimlet_dispatch if gimlet_dispatch

if ngx
	gimlet_dispatch = require "gimlet.backend.nginx"
else
	gimlet_dispatch = require "gimlet.backend.wsapi"

gimlet_dispatch
