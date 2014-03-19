class Route
	new: (method, pattern, handler) =>
		@method = method
		@pattern = pattern
		@handler = handler

	validate: =>

class Router
	new: =>
		@routes = {}

	add_route: (method, pattern, handler) =>
		route = Route method, pattern, handler
		route\validate!
		@routes = table.insert @routes, route
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

	not_found: (handler) =>
		@add_route '404', handler

	handle: =>

{:Route, :Router}
