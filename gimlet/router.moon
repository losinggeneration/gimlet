import validate_handler from require "gimlet.utils"

class Route
	new: (method, pattern, handlers) =>
		@method = method
		@pattern = pattern
		@handlers = handlers

		-- This next part gets the parameters from the pattern
		-- It grabs the location for the two pattern sets and puts them into
		-- a table. It then reindexes them from 1. Once that this is all done,
		-- The pattern to pass to the string.{match,find,etc} functions is
		-- constructed. This then allows the named and numbered parameters to
		-- be looked up in the @params table when the path matches.

		-- Get a list of named parameters
		tmp_params = {}
		for i, n in string.gmatch pattern, '():([^/#?]+)' do
			tmp_params[i] = n

		-- Get a list of numbered parameters
		idx = 1
		for i in string.gmatch pattern, '()%*%*' do
			tmp_params[i] = idx
			idx += 1

		-- Squash the parameters into the correct order
		@params = [ n for _, n in pairs tmp_params ]

		-- Escape some valid parts of the url
		@str_match = string.gsub pattern, '[-.]', '%%%1'
		-- Add an optional / at the end of the url
		@str_match ..= "/?"
		-- Change the named parameters to a normal capture
		@str_match = string.gsub @str_match, ':([^/#?]+)', '([^/#?]+)'
		-- Change the numbered parameters intor normal captures
		@str_match = string.gsub @str_match, '(%*%*)', '([^#?]*)'

	validate: =>
		validate_handler h for h in *@handlers

	match_method: (method) =>
		return @method == '*' or method == @method or (method == 'HEAD' and @method == 'GET')

	match: (method, path) =>
		return nil unless @match_method method

		matches = { string.find path, @str_match }
		if #matches > 0 and string.sub(path, matches[1], matches[2]) == path
			-- skip matches 1 & 2 since those are the path substring
			return {@params[i-2], match for i, match in ipairs matches when i > 2}

		return nil

	handle: (params, response) =>
		response\write handler(params) for handler in *@handlers

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

	-- Goes through added routes and calls the handler on matches
	-- @param response Should have a \write method for writting to the response
	-- @param method the HTTP method to check for a match. Assumed to be all uppercase letters
	-- @param path the path portion of the URL to check for a match
	handle: (response, method, path) =>
		for route in *@routes
			params = route\match method, path
			if params
				route\handle params, response
				return

		-- No routes matched, 404
		error "Not Found. Just erroring for now"

{:Route, :Router}
