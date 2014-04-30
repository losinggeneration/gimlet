dispatch = (gimlet) ->
	unless gimlet.content_type
		ngx.header["Content-Type"] = "text/html"
	else
		ngx.header["Content-Type"] = gimlet.content_type

	res = class
		write: (...) =>
			ngx.print ...

		set_options: (options) =>
			ngx.header["Content-Type"] = options["Content-Type"] if options["Content-Type"]
			unless options.headers == nil
				ngx.headers[k] = v for k, v in pairs(options.headers)
			@status options.status unless options.status == nil

		status: (s) =>
			ngx.status = s unless s == nil
			ngx.status

	req = class
		new: =>
			@url_path = ngx.var.uri
			@request_uri = ngx.var.request_uri
			@query_params = ngx.req.get_uri_args!
			@method = ngx.req.get_method!
			@post_args = {}
			if @method == 'POST'
				ngx.req.read_body!
				@post_args = ngx.req.get_post_args!

	util = class
		now: ->
			ngx.now!

	request = req!
	response = res!
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

	gimlet\action mapped, request.method, request.url_path unless finish == false

	c = true
	while c
		ngx.update_time!
		c = false
		for middleware in *coros
			switch coroutine.status(middleware)
				when "suspended"
					coroutine.resume middleware, mapped
					c = true

	response\status!

{:dispatch}
