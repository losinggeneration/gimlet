dispatch = (gimlet) ->
	wsapi_run = (env) ->
		headers = nil
		unless gimlet.content_type
			headers = {["Content-Type"]: "application/json"}
		else
			headers = {["Content-Type"]: gimlet.content_type}

		wsapi_request = require "wsapi.request"
		wsapi_response = require "wsapi.response"
		wsapi_util = require "wsapi.util"

		req = wsapi_request.new env
		res = wsapi_response.new 200, headers

		resWrap = class
			write: (...) =>
				res\write ...

			set_options: (options) =>
				headers["Content-Type"] = options["Content-Type"] if options["Content-Type"]
				@status options.status unless options.status == nil

			status: (s) =>
				res.status = s unless s == nil
				res\status!

		reqWrap = class
			new: =>
				@url_path = req.path_info
				@method = req.method

		util = class
			now: ->
				os.time!

		request = reqWrap!
		response = resWrap!
		utils = util!
		mapped = gimlet._mapped
		mapped.request = request
		mapped.response = response
		mapped.utils = utils

		coros = [coroutine.create middleware for middleware in *gimlet._handlers]
		coroutine.resume middleware, mapped for middleware in *coros

		gimlet\action mapped, req.method, req.path_info

		c = true
		while c
			c = false
			for middleware in *coros
				switch coroutine.status(middleware)
					when "suspended"
						coroutine.resume middleware, mapped
						c = true

		res\finish!

	if gimlet.cgi
		import run from require "wsapi.cgi"
		return run wsapi_run
	elseif gimlet.fcgi
		import run from require "wsapi.fastcgi"
		return run wsapi_run

	return {run: wsapi_run}

{:dispatch}
