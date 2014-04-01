-- format time
ft = (t) ->
	os.date("%F %T", t)

Logger = (log) ->
	(req, res, utils) ->
		start = utils.now!
		log\write string.format "%s - Started %s %s\n", ft(start), req.method, req.url_path

		coroutine.yield!

		log\write string.format "%s - Completed %s %s (%d) in %.4f seconds\n", ft(utils.now!), req.method, req.url_path, res\status!, utils.now! - start

{:Logger}
