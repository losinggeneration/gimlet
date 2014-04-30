Static = (path, ...) ->
	args = {...}
	(p) ->
		if string.sub(p.request.url_path, 1, string.len(path)) == path
			-- TODO if the filename is a directory, the behavior is currently undefined
			filename = '.' .. p.request.url_path
			f = io.open filename, 'r'
			if f == nil
				p.response\status 404
				return

			pcall ->
				mimetypes = require 'mimetypes'
				p.response\set_options {'Content-Type': mimetypes.guess filename}

			args[1].log\write string.format '%s - [Static] Serving %s\n', os.date('%F %T', p.utils.now!), filename if #args and args[1].log
			p.response\write f\read '*a'

			false

{:Static}
