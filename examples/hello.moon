-- This provides a default instance of Classic from gimlet.gimlet
require "gimlet"

get "/hello-world", ->
	"Hello World!"

run!
