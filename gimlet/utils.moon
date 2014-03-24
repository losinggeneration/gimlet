validate_handler = (handler) ->
	error "Gimlet handler must be a function" if type(handler) != "function"

{ :validate_handler }
