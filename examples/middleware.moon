classic = require "gimlet.classic"

classic.map "db", {msg: "pretend this is a database object mapped"}

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

classic.get "/mapped", (p) ->
	p.db.msg

classic.get "/:hello", (p) ->
	"hello " .. p.params.hello

classic.run!
