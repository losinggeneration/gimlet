import validate_handler from require "gimlet.utils"
import encode from require "cjson"

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
		-- The maximum index match of the pattern
		tmp_params_max = 0
		for i, n in string.gmatch pattern, '():([^/#?]+)' do
			tmp_params[i] = n
			tmp_params_max = i if i > tmp_params_max

		-- Get a list of numbered parameters
		idx = 1
		for i in string.gmatch pattern, '()%*%*' do
			tmp_params[i] = idx
			tmp_params_max = i if i > tmp_params_max
			idx += 1

		-- fill out the table so ipairs works across the table
		empty = {}
		for i=1, tmp_params_max
			tmp_params[i] = empty if tmp_params[i] == nil

		-- Squash the parameters into the correct order
		@params = [ n for n in *tmp_params when n != empty ]

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

	handle: (mapped) =>
		for handler in *@handlers
			options, output = handler(mapped)
			if type(options) == 'string'
				mapped.response\write options
			else
				mapped.response\set_options options
				if output == nil and options.json != nil
					mapped.response\write encode options.json
				else
					mapped.response\write output

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
	handle: (mapped, method, path) =>
		for route in *@routes
			params = route\match method, path
			if params
				mapped.params = params
				route\handle mapped
				return

		-- No routes matched, 404
		error "Not Found. Just erroring for now"

{:Route, :Router}
