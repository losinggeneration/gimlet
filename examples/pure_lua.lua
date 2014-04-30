-- This provides a default instance of Classic from gimlet.init
local classic = require 'gimlet.classic'

classic.get('/', function()
	return 'This is the default route. Try /hello-world.'
end)

classic.get('/hello-world', function()
	return 'Hello World!'
end)

classic.get("/hello", function(p)
	for k, v in pairs(p.request.query_params) do
		p.response:write(string.format('<p><b>%s</b>: <i>%s</i></p>', k, v))
	end
end)

classic.get("/hello/:name", function(p)
	return string.format("Hello %s!", p.params.name)
end)

classic.get('/goodbye/:name', function (p)
	local json = require 'cjson'
	return { ['Content-Type'] = 'application/json' }, json.encode({ goodbye = p.params.name })
end)

classic.post('/hello-world', function (p)
	return string.format("POST: Hello %s!", p.request.post_args.name or 'World')
end)

classic.get("/hello/:name/**/**", function (p)
	return string.format("name=%s,**(1)=%s,**(2)=%s", p.params.name, p.params[1], p.params[2])
end)

classic.run()
