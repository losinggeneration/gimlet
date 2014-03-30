-- This provides a default instance of Classic from gimlet.gimlet
require "gimlet"

get "/", ->
	"Default Route. Try: /hello-world"

get "/hello-world", ->
	"Hello World!"

get "/:name", (params) ->
	string.format "name=%s", params.name

get "/:name/**/**", (params) ->
	string.format "name=%s,**(1)=%s,**(2)=%s", params.name, params[1], params[2]

run!
