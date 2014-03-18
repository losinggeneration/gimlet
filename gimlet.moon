validate_handler = (handler) ->
	assert type(handler) == "function", "Gimlet handler must be a function"

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

class Classic extends Gimlet
	new: =>
		@super!
		@router = Router!
		@use Logger!
		@use Static "public"
		@action @router.handle
