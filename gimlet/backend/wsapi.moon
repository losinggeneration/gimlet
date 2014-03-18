request = require "wsapi.request"
response = require "wsapi.response"
util = require "wsapi.util"

module ..., package.seeall

dispatch = (gimlet) ->
	wsapi_run = (env) ->
		headers = {["Content-Type"]: "text/html"}
		stub = ->
			coroutine.yield "<html><body>"
			coroutine.yield string.format "<p>Gimlet!</p>"
			coroutine.yield string.format "<p>just a stub for now</p>"
			coroutine.yield "</body></html>"

		200, headers, coroutine.wrap(stub)

	if gimlet.cgi
		import run from require "wsapi.cgi"
		return run wsapi_run
	elseif gimlet.fcgi
		import run from require "wsapi.fastcgi"
		return run wsapi_run

	return {run: wsapi_run}

{:dispatch}
