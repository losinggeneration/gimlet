-- Copyright 2014 Harley Laue
-- Copyright 2014 Leaf Corcoran
-- The run function is basically lapis.serve

import dispatch from require "gimlet.dispatcher"

export gimlet_cache = gimlet_cache or {}

runner = (gimlet_cls) ->
	gimlet = gimlet_cache[gimlet_cls]

	unless gimlet
		gimlet = if type(gimlet_cls) == "string"
			require(gimlet_cls)!
		elseif gimlet_cls.__base
			gimlet_cls!
		else
			gimlet_cls

		gimlet_cache[gimlet_cls] = gimlet

	dispatch gimlet

{ :runner }
