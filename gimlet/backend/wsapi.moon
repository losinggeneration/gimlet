common = require "gimlet.backend.common"

request = class extends common.request
	wsapi_request = require "wsapi.request"

	new: (env) =>
		req = wsapi_request.new(env)
		@url_path = req.path_info
		@query_params = req.GET
		@request_uri = req.path_info .. '/' .. req.query_string
		@method = req.method
		@post_args = if req.method == 'POST'
			req.POST
		else
			{}

response = class extends common.response
	res = nil
	headers = nil
	wsapi_response = require "wsapi.response"

	-- not in common.response
	new: (code, context_type = "text/html") =>
		headers = {["Content-Type"]: content_type}

		res = wsapi_response.new code, headers

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

	-- not in common.response
	finish: => res\finish!

utils = class extends common.utils
	now: -> os.time!

dispatch = (gimlet) ->
	wsapi_run = (env) ->
		mapped = with gimlet._mapped
			.request = request env
			.response = response 200, gimlet.content_type
			.utils = utils!

		coros = [coroutine.create middleware for middleware in *gimlet._handlers]
		local finish
		for middleware in *coros
			if finish
				coroutine.resume middleware, mapped
			else
				_, finish = coroutine.resume middleware, mapped

		gimlet\action mapped, mapped.request.method, mapped.request.url_path unless finish == false

		c = true
		while c
			c = false
			for middleware in *coros
				switch coroutine.status(middleware)
					when "suspended"
						coroutine.resume middleware, mapped
						c = true

		mapped.response\finish!

	if gimlet.cgi
		import run from require "wsapi.cgi"
		return run wsapi_run
	elseif gimlet.fcgi
		import run from require "wsapi.fastcgi"
		return run wsapi_run

	return {run: wsapi_run}

{:dispatch}
