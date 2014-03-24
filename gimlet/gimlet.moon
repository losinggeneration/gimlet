import is_object, mixin from require "moon"

import Logger from require "gimlet.logger"
import Recovery from require "gimlet.recovery"
import Router from require "gimlet.router"
import Static from require "gimlet.static"
import runner from require "gimlet.init"
import validate_handler from require "gimlet.utils"

class Gimlet
	new: =>
		@action = =>
		@_handlers = {}
	
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

	-- Run the application
	run: =>
		runner @

class Classic
	new: =>
		mixin self, Gimlet
		mixin self, Router

		@use Logger!
		@use Recovery!
		@use Static "public"
		@set_action @handle

{:Gimlet, :Classic}
