-- Copyright 2014 Harley Laue
-- Copyright 2014 Leaf Corcoran
-- The runner function is basically lapis.serve

import dispatch from require "gimlet.dispatcher"

gimlet_cache = {}

runner = (gimlet_cls) ->
	gimlet = gimlet_cache[gimlet_cls]

	unless gimlet
		gimlet = if type(gimlet_cls) == "string"
			require(gimlet_cls)!
		elseif gimlet_cls.__base
			gimlet_cls!
		else
			gimlet_cls

		gimlet_cache[gimlet_cls] = gimlet

	dispatch gimlet

import mixin from require "moon"

import Logger from require "gimlet.logger"
import Router from require "gimlet.router"
import Static from require "gimlet.static"
import validate_handler from require "gimlet.utils"

class Gimlet
	new: =>
		@action = =>
		@_handlers = {}
		@_mapped = {}

	-- Sets the entire middleware table with the given handlers.
	-- This will clear any current middleware handlers.
	-- error will be inoked if any handler is not a callable function.
	handlers: (...) =>
		@_handlers = {}
		for _, h in pairs {...}
			@use h

	-- Sets the handler that will be called after the middleware has been invoked.
	-- This is set to Router in Classic
	set_action: (handler) =>
		validate_handler handler
		@action = handler

	-- Use adds a middleware handler to the stack.
	-- Midleware handlers are invoked in the order that they are added.
	-- error is invoked if the handler is not a callable function.
	use: (handler) =>
		validate_handler handler
		table.insert @_handlers, handler

	map: (name, value) =>
		@_mapped[name] = value

	-- Run the application
	run: =>
		runner @

class Classic
	new: (log = io.stdout) =>
		mixin self, Gimlet
		mixin self, Router

		@use Logger log
		@use Static "public"
		@set_action @handle

{:Gimlet, :Classic}

