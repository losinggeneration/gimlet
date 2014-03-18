if ngx != nil
	import dispatch from require "gimlet.backend.nginx"
else
	import dispatch from require "gimlet.backend.wsapi"

{:dispatch}
