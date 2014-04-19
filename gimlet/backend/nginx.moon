dispatch = (gimlet) ->
	unless gimlet.content_type
		ngx.header["Content-Type"] = "application/json"
	else
		ngx.header["Content-Type"] = gimlet.content_type

	res = class
		write: (...) =>
			ngx.print ...

		set_options: (options) =>
			ngx.header["Content-Type"] = options["Content-Type"] if options["Content-Type"]

		status: =>
			ngx.status

	req = class
		new: =>
			@url_path = ngx.var.request_uri
			@method = ngx.req.get_method!

	util = class
		now: ->
			ngx.now!

	request = req!
	response = res!
	utils = util!

	coros = [coroutine.create middleware for middleware in *gimlet._handlers]
	coroutine.resume middleware, :request, :response, :utils for middleware in *coros

	gimlet\action response, request.method, request.url_path

	c = true
	while c
		ngx.update_time!
		c = false
		for middleware in *coros
			switch coroutine.status(middleware)
				when "suspended"
					coroutine.resume middleware, :request, :response, :utils
					c = true

	response\status!

{:dispatch}
