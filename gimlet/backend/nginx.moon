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
	coroutine.resume middleware, mapped for middleware in *coros

	gimlet\action mapped, request.method, request.url_path

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
