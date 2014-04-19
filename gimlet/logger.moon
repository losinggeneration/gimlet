-- format time
ft = (t) ->
	os.date("%F %T", t)

Logger = (log) ->
	(p) ->
		start = p.utils.now!
		log\write string.format "%s - Started %s %s\n", ft(start), p.request.method, p.request.url_path

		p = coroutine.yield!

		log\write string.format "%s - Completed %s %s (%d) in %.4f seconds\n", ft(p.utils.now!), p.request.method, p.request.url_path, p.response\status!, p.utils.now! - start

{:Logger}
