-- This provides a default instance of Classic from gimlet.init
classic = require "gimlet.classic"

classic.get "/", ->
	"Default Route. Try: /hello-world"

classic.get "/hello-world", ->
	"Hello World!"

classic.get "/:name", (params) ->
	string.format "name=%s", params.name

classic.get "/:name/**/**", (params) ->
	string.format "name=%s,**(1)=%s,**(2)=%s", params.name, params[1], params[2]

classic.run!
