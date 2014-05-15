#Gimlet Cocktail
version **0.1.0**

Gimlet Cocktail is a micro web application framework for [OpenResty](http://openresty.org/)[[2](#getting-started-note-2)] written in [Moonscript](http://moonscript.org/). The hope is that it's useful, modular, and makes writting web applications (espcially REST ones) quick and fun.

##Getting started

* First thing to do is to install Moonscript [[1](#getting-started-note-1)]
* To use the command line tool, you'll need a couple more dependencies:
  * lua_cliargs >= 2.1 - For command line argument parsing.
  * luafilesystem >= 1.5 - For ensuring the web server is running from the correct location.
* Then you should make sure to either have OpenResty installed
* (Alternatively) Install wsapi, wsapi-xavante, & xavante.

* Create a file named app.moon with the following code:
```moonscript
import get, run from require 'gimlet.classic'

get '/', ->
  'Hello world!'

run!
```
* Now you can compile the code with ```moonc app.moon```
* You can run use the gimlet command to start the server ```gimlet app``` [[2](#getting-started-note-2)]

You will now have a Gimlet application running on your web server of choice on ```http://localhost:8080```

[<a name="getting-started-note-1">1</a>] All dependencies can be installed via LuaRocks.

[<a name="getting-started-note-2">2</a>] The default is use use OpenResty. [Xavante](http://keplerproject.github.io/xavante) can be used by using ```gimlet -x app```

##Table of Contents
* [Classic Gimlet](#classic-gimlet)
  * [Handlers](#handlers)
  * [Routing](#routing)
  * [Services](#services)
  * [Serving Static Files](#serving-static-files)
* [Middleware Handlers](#middleware-handlers)
  * [Middleware Yielding](#middleware-yielding)
* [Available Middleware](#available-middleware)
* [Code Reloading](#code-reloading)
* [Using Lua](#using-lua)

##Classic Gimlet
 ```gimlet.classic``` tries to provide reasonable defaults for most web applications. The general pieces are requiring ```gimlet.classic```, setting up any additional middleware, adding items to be passed to the routes, setting up your routing information, and running the application.
```moonscript
-- Pull in the Classic Gimlet
classic = require 'gimlet.classic'

-- Optionally define a variable to be available to all requests
classic.map "world", 'World'

-- Define a middleware to use
classic.use (require 'gimlet.render').Render!

-- Define a route '/' with params
classic.get '/', (params) ->
  params.render.json hello: params.world

-- Run the Gimlet application
classic.run!
```

###Handlers
Handlers are how you get things done in Gimlet (as they are in Martini.) A handler is a any callable function.
```moonscript
classic.get '/', ->
  print "hello world"
```

####Return Values
Handlers can return a string value and that will be sent back as a simple HTTP HTML response. 
```moonscript
classic.get '/', ->
  "hello world" -- HTTP 200 : "hello world"
```
If the first option is numeric, it changes the HTTP response code.
```moonscript
classic.get '/', ->
  418, "i'm a teapot" -- HTTP 418 : "i'm a teapot"
```

If the first option is a table, other things about the HTTP response can be changed, such as Content-Type, headers, and the status.
```moonscript
classic.get '/', ->
  'Content-Type': 'application/json', status: 401, [[{"error": "you're not authorized to access content"}]]
```

####Parameters
The handlers can optionally take a single table parameter.
```moonscript
classic.get '/', (p) ->
  p.utils.now!
```
The following are mapped to the table by default:
* gimlet - An instance of the Gimlet class
* request - An instance of the HTTP request object
* response - An instance of the HTTP response object.
* utils - An instance of some utility functions

In addition to these, route globs and named parameters are mapped to the parameter as well. See [Routing](#routing) for more information on this.

###Routing
In Gimlet, a route is an HTTP method paired with a URL-matching pattern. Each route can take one or more handler methods:
```moonscript
classic.get '/', ->
  -- show something

classic.patch '/', ->
  -- update something

classic.post '/', ->
  -- create something

classic.put '/', ->
  -- replace something

classic.delete '/', ->
  -- destroy something

classic.options '/', ->
  -- http options

classic.not_found ->
  -- handle 404
```

Routes are matched in the order they are defined. The first route that matches the request is invoked.

Route patterns may include named parameters:
```moonscript
classic.get '/:name', (p) ->
  'hello ' .. p.params.name
```

Routes can be matched with globs:
```moonscript
classic.get '/**', (p) ->
  'hello ' .. p.params[1]
```
Route groups can be added too using the group method:
```moonscript
classic.group '/books', (r) ->
  r\get '', get_books
  r\get '/:id', get_book
  r\post '/new', new_book
  r\put '/update/:id', update_book
  r\delete '/delete/:id', delete_book
```
###Services
Services are objects that are available to be injected into a handler's parameters table.

```moonscript
db = my_database!
classic.map "db", db -- the service will be available to all handlers as -> (p) p.db
-- ...
classic.run!
```

###Serving Static Files
```gimlet.classic``` automatically serves files from ```public``` relative to the main module.

Alternatively, you can let the HTTP server handle static files with ```gimlet -s static_dir app```

##Middleware Handlers
Middlware handlers sit between the incoming http request and the router. They are, in essence, no different than any other handler in Gimlet. You can add a middleware handler to the stack with:
```moonscript
classic.use ->
  -- do middleware stuff
```

You also have full control over the middleware stack with the ```Gimlet\handlers``` function. This will replace all handlers that were previously set:
```moonscript
classic.handlers middleware1, middleware2, middleware3
```

Middleware handlers tend to work well for things like: logging, authorization, authentication, sessions, errors, or anything else that needs to happen before and/or after an HTTP request.

###Middleware Yielding
During a middleware handler call, the middleware can optionally call ```coroutine.yield```. This allows somet things to happen before and after the request.
```moonscript
classic.use ->
  print "before a request"

  coroutine.yield!

  print "after a request"
```

##Available Middleware
* [Render](http://github.com/losinggeneration/gimlet-render) - Handles rendering JSON & HTML templates.

##Code Reloading
Code reloading is accomplished by using ```gimlet -r``` It works well with OpenResty. However, Xavante seems to have some issues currently.

##Using Lua
Up until this point, Moonscript has been assumed for everything. There's, currently limited, support for using Lua.
```lua
local classic = require 'gimlet.classic'

classic.get('/', function()
        return 'Hello world!'
end)

classic.run()
```

##About
Gimlet Cocktail is inspired by projcets like [Martini](http://github.com/go-martini/martini) and [Sinatra](https://github.com/sinatra/sinatra). Some code is heavily based off Martini as well.

