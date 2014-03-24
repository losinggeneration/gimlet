import validate_handler from require "gimlet.utils"

class Route
	new: (method, pattern, handlers) =>
		@method = method
		@pattern = pattern
		@handlers = handlers
		@str_match = string.gsub pattern, '[-*.]', '%%%1'

	validate: =>
		validate_handler h for h in *@handlers

	match_method: (method) =>
		return @method == '*' or method == @method or (method == 'HEAD' and @method == 'GET')

	match: (method, path) =>
		return nil unless @match_method method

		matches = { string.match path, @str_match }
		if #matches > 0 and matches[1] == path
			return [match for match in *matches[2,]]

		return nil

	handle: (params, response) =>
		error "route handle"

class Router
	new: =>
		@routes = {}
		@not_founds = {}

	add_route: (method, pattern, handler) =>
		route = Route method, pattern, {handler}
		route\validate!
		table.insert @routes, route
		route

	get: (pattern, handler) =>
		@add_route 'GET', pattern, handler

	post: (pattern, handler) =>
		@add_route 'POST', pattern, handler

	put: (pattern, handler) =>
		@add_route 'PUT', pattern, handler

	delete: (pattern, handler) =>
		@add_route 'DELETE', pattern, handler

	patch: (pattern, handler) =>
		@add_route 'PATCH', pattern, handler

	options: (pattern, handler) =>
		@add_route 'OPTIONS', pattern, handler

	head: (pattern, handler) =>
		@add_route 'HEAD', pattern, handler

	any: (pattern, handler) =>
		@add_route 'ANY', pattern, handler

	-- Add handlers
	not_found: (...) =>
		@not_founds = { ... }

	handle: (response, method, path) =>
		for route in *@routes
			params = route\match method, path
			if params
				route\handle parems, response
				return

		-- No routes matched, 404
		error "Not Found. Just erroring for now"

{:Route, :Router}
