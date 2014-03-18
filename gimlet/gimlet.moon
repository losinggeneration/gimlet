import mixin from require "moon"

import Logger from require "gimlet.Logger"
import Router from require "gimlet.Router"
import Static from require "gimlet.Static"

validate_handler = (handler) ->
	error "Gimlet handler must be a function" if type(handler) != "function"

class Gimlet
	new: =>
		@action = ->

	handlers: (...) =>
		@_handlers = {}
		for _, h in pairs {...}
			@use h

	action: (handler) =>
		validate_handler handler
		@action = handler

	use: (handler) =>
		validate_handler handler
		@_handlers = table.insert @_handlers, handler

	run: =>

class Classic
	new: =>
		mixin self, Gimlet
		mixin self, Router

		@use Logger!
		@use Static "public"
		@action @router.handle

{:Gimlet, :Classic}
