-- This provides a default instance of Classic from gimlet.init
classic = require "gimlet.classic"
json = require 'cjson'

classic.get "/", ->
	"Default Route. Try: /hello-world"

classic.get "/hello-world", ->
	"Hello World!"

classic.get "/hello", (p) ->
	for k,v in pairs p.request.query_params
		p.response\write string.format '<p><b>%s</b>: <i>%s</i></p>', k, v

classic.get "/hello/:name", (p) ->
	string.format "Hello %s!", p.params.name

classic.get '/goodbye/:name', (p) ->
	'Content-Type': 'application/json', json.encode { goodbye: p.params.name }

classic.post '/hello-world', (p) ->
	string.format "POST: Hello %s!", p.request.post_args.name or 'World'

classic.get "/hello/:name/**/**", (p) ->
	string.format "name=%s,**(1)=%s,**(2)=%s", p.params.name, p.params[1], p.params[2]

classic.run!
