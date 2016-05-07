request = class
	url_path: '"Not Implemented"'
	query_params: '"Not Implemented"'
	request_uri: '"Not Implemented"'
	method: '"Not Implemented"'
	post_args: '"Not Implemented"'

response = class
	write: (...) => '"Not Implemented"'
	set_options: (options) => '"Not Implemented"'
	status: (s) => '"Not Implemented"'

utils = class
	now: -> '"Not Implemented"'

{ :request, :response, :utils }
