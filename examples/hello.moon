-- This provides a default instance of Classic from gimlet.gimlet
require "gimlet"

get "/", ->
	"Default Route. Try: /hello-world"

get "/hello-world", ->
	"Hello World!"

get "/:name/**", (params) ->
	string.format "name=%s,**=%s", params.name, params[1]

run!
