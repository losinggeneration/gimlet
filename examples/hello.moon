-- This provides a default instance of Classic from gimlet.init
classic = require "gimlet.classic"

classic.get "/", ->
	"Default Route. Try: /hello-world"

classic.get "/hello-world", ->
	"Hello World!"

classic.get "/hello/:name", (p) ->
	string.format "Hello %s!", p.params.name

classic.post '/hello-world', (p) ->
	string.format "POST: Hello %s!", p.request.post_args.name or 'World'

classic.get "/hello/:name/**/**", (p) ->
	string.format "name=%s,**(1)=%s,**(2)=%s", p.params.name, p.params[1], p.params[2]

classic.run!
