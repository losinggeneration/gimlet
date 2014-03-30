-- This provides a default instance of Classic from gimlet.gimlet
-- Ngninx seems to require this for lua_code_cache on to work
-- The first request will work if we use the bare require, but subsequent
-- requests will fail with error 500, specifically "get" is undefined
classic = require "gimlet"

classic.get "/", ->
	"Default Route. Try: /hello-world"

classic.get "/hello-world", ->
	"Hello World!"

classic.get "/:name", (params) ->
	string.format "name=%s", params.name

classic.get "/:name/**/**", (params) ->
	string.format "name=%s,**(1)=%s,**(2)=%s", params.name, params[1], params[2]

classic.run!
