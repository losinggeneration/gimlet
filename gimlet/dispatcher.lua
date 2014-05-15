local gimlet_dispatch
if ngx then
  gimlet_dispatch = require("gimlet.backend.nginx")
else
  gimlet_dispatch = require("gimlet.backend.wsapi")
end
return gimlet_dispatch
