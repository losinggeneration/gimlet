package = "gimlet-cocktail"
version = "0.1.0-3"

source = {
	url = "git://github.com/losinggeneration/gimlet.git",
	branch = "0.1.0",
}

description = {
	summary = "A micro web framework inspired by Martini and Sinatra.",
	homepage = "http://losinggeneration.github.io/gimlet",
	maintainer = "Harley Laue <losinggeneration@gmail.com>",
	license = "MIT"
}

dependencies = {
	"lua >= 5.1",
	"lua_cliargs >= 2.1",
	"luafilesystem >= 1.5",
	"xavante >= 2.3.0",
	"wsapi-xavante >= 1.6",
	"wsapi >= 1.6",
}

build = {
	type = "builtin",
	modules = {
		["gimlet"] = "gimlet/init.lua",
		["gimlet.classic"] = "gimlet/classic.lua",
		["gimlet.dispatcher"] = "gimlet/dispatcher.lua",
		["gimlet.logger"] = "gimlet/logger.lua",
		["gimlet.router"] = "gimlet/router.lua",
		["gimlet.static"] = "gimlet/static.lua",
		["gimlet.utils"] = "gimlet/utils.lua",
		["gimlet.version"] = "gimlet/version.lua",
		["gimlet.backend.nginx"] = "gimlet/backend/nginx.lua",
		["gimlet.backend.wsapi"] = "gimlet/backend/wsapi.lua",
	},
	install = {
		bin = { "bin/gimlet", }
	}
}

