classic = require "gimlet"

classic.use (...) ->
	import p from require "moon"
	print "middleware: before"
	p {...}
	args = {coroutine.yield!}
	print "middleware: after"
	p args

classic.get "/", ->
	print "get: /"
	"/"

classic.get "/:hello", (p) ->
	"hello " .. p.params.hello

classic.run!
