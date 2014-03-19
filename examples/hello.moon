import Classic from require "gimlet.gimlet"

c = Classic!

c\get "/hello-world", ->
	"Hello World!"

c\run!
