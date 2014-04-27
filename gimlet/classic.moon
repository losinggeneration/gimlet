import Classic from require "gimlet.init"

classic = Classic!

handlers = (...) ->
	classic\handlers ...

action = (handler) ->
	classic\action handler

use = (handler) ->
	classic\use handler

run = ->
	classic\run!

add_route = (method, pattern, handler) ->
	classic\add_route pattern, handler

group = (pattern, fn, handler) ->
	classic\group pattern, fn, handler

get = (pattern, handler) ->
	classic\get pattern, handler

post = (pattern, handler) ->
	classic\post pattern, handler

put = (pattern, handler) ->
	classic\put pattern, handler

delete = (pattern, handler) ->
	classic\delete pattern, handler

patch = (pattern, handler) ->
	classic\patch pattern, handler

options = (pattern, handler) ->
	classic\options pattern, handler

head = (pattern, handler) ->
	classic\head pattern, handler

any = (pattern, handler) ->
	classic\any pattern, handler

not_found = (...) ->
	classic\not_found ...

map = (name, value) ->
	classic\map name, value

{
	:handlers
	:action
	:use
	:run
	:add_route
	:group
	:get
	:post
	:put
	:delete
	:patch
	:options
	:head
	:any
	:not_found
	:map
}
