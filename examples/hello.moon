-- This provides a default instance of Classic from gimlet.init
classic = require "gimlet.classic"

classic.get "/", ->
	"Default Route. Try: /hello-world"

classic.get "/hello-world", ->
	"Hello World!"

classic.get "/:name", (p) ->
	string.format "name=%s", p.params.name

classic.get "/:name/**/**", (p) ->
	string.format "name=%s,**(1)=%s,**(2)=%s", p.params.name, p.params[1], p.params[2]

classic.run!
