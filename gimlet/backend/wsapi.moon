dispatch = (gimlet) ->
	wsapi_run = (env) ->
		headers = nil
		unless gimlet.content_type
			headers = {["Content-Type"]: "text/html"}
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
				unless options.headers == nil
					headers[k] = v for k, v in pairs options.headers
				@status options.status unless options.status == nil

			status: (s) =>
				res.status = s unless s == nil
				res.status

		reqWrap = class
			new: =>
				@url_path = req.path_info
				@query_params = req.GET
				@request_uri = req.path_info .. '/' .. req.query_string
				@method = req.method
				@post_args = {}
				if @method == 'POST'
					@post_args = req.POST

		util = class
			now: ->
				os.time!

		request = reqWrap!
		response = resWrap!
		utils = util!
		mapped = with gimlet._mapped
			.request = request
			.response = response
			.utils = utils

		coros = [coroutine.create middleware for middleware in *gimlet._handlers]
		local finish
		for middleware in *coros
			if finish
				coroutine.resume middleware, mapped
			else
				_, finish = coroutine.resume middleware, mapped

		gimlet\action mapped, req.method, req.path_info unless finish == false

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
