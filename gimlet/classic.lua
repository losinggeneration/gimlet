local Classic
do
  local _obj_0 = require("gimlet.init")
  Classic = _obj_0.Classic
end
local classic = Classic()
local handlers
handlers = function(...)
  return classic:handlers(...)
end
local action
action = function(handler)
  return classic:action(handler)
end
local use
use = function(handler)
  return classic:use(handler)
end
local run
run = function()
  return classic:run()
end
local add_route
add_route = function(method, pattern, handler)
  return classic:add_route(pattern, handler)
end
local group
group = function(pattern, fn, handler)
  return classic:group(pattern, fn, handler)
end
local get
get = function(pattern, handler)
  return classic:get(pattern, handler)
end
local post
post = function(pattern, handler)
  return classic:post(pattern, handler)
end
local put
put = function(pattern, handler)
  return classic:put(pattern, handler)
end
local delete
delete = function(pattern, handler)
  return classic:delete(pattern, handler)
end
local patch
patch = function(pattern, handler)
  return classic:patch(pattern, handler)
end
local options
options = function(pattern, handler)
  return classic:options(pattern, handler)
end
local head
head = function(pattern, handler)
  return classic:head(pattern, handler)
end
local any
any = function(pattern, handler)
  return classic:any(pattern, handler)
end
local not_found
not_found = function(...)
  return classic:not_found(...)
end
local map
map = function(name, value)
  return classic:map(name, value)
end
return {
  handlers = handlers,
  action = action,
  use = use,
  run = run,
  add_route = add_route,
  group = group,
  get = get,
  post = post,
  put = put,
  delete = delete,
  patch = patch,
  options = options,
  head = head,
  any = any,
  not_found = not_found,
  map = map
}
