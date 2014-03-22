import runner from require "gimlet.init"
import Classic from require "gimlet.gimlet"

classic = Classic!

export handlers = (...) ->
	classic\handlers ...

export action = (handler) ->
	classic\action handler

export use = (handler) ->
	classic\use handler

export run = ->
	runner classic

export add_route = (method, pattern, handler) ->
	classic\add_route pattern, handler

export get = (pattern, handler) ->
	classic\get pattern, handler

export post = (pattern, handler) ->
	classic\post pattern, handler

export put = (pattern, handler) ->
	classic\put pattern, handler

export delete = (pattern, handler) ->
	classic\delete pattern, handler

export patch = (pattern, handler) ->
	classic\patch pattern, handler

export options = (pattern, handler) ->
	classic\options pattern, handler

export head = (pattern, handler) ->
	classic\head pattern, handler

export any = (pattern, handler) ->
	classic\any pattern, handler

export not_found = (handler) ->
	classic\not_found pattern, handler

{
	:handlers,
	:action,
	:use,
	:run,
	:add_route,
	:get,
	:post,
	:put,
	:delete,
	:patch,
	:options,
	:head,
	:any,
	:not_found,
}
