import is_object, mixin from require "moon"

import Logger from require "gimlet.logger"
import Router from require "gimlet.router"
import Static from require "gimlet.static"
import run from require "gimlet.init"

validate_handler = (handler) ->
	error "Gimlet handler must be a function" if type(handler) != "function"

class Gimlet
	new: =>
		@action = ->
		@_handlers = {}

	handlers: (...) =>
		@_handlers = {}
		for _, h in pairs {...}
			@use h

	action: (handler) =>
		validate_handler handler
		@action = handler

	use: (handler) =>
		validate_handler handler
		table.insert @_handlers, handler

	run: =>
		run @

class Classic
	new: =>
		mixin self, Gimlet
		mixin self, Router

		@use Logger!
		@use Static "public"
		@action handle

{:Gimlet, :Classic}
