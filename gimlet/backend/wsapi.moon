request = require "wsapi.request"
response = require "wsapi.response"
util = require "wsapi.util"

module ..., package.seeall

dispatch = (gimlet) ->
	wsapi_run = (env) ->
		headers = nil
		unless gimlet.content_type
			headers = {["Content-Type"]: "application/json"}
		else
			headers = {["Content-Type"]: gimlet.content_type}

		req = request.new env
		res = response.new env

		stub = ->
			coroutine.yield gimlet\action res, req.method, req.path_info

		200, headers, coroutine.wrap(stub)

	if gimlet.cgi
		import run from require "wsapi.cgi"
		return run wsapi_run
	elseif gimlet.fcgi
		import run from require "wsapi.fastcgi"
		return run wsapi_run

	return {run: wsapi_run}

{:dispatch}
