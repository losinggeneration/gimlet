local Static
Static = function(path, ...)
  local args = {
    ...
  }
  return function(p)
    if string.sub(p.request.url_path, 1, string.len(path)) == path then
      local filename = '.' .. p.request.url_path
      local f = io.open(filename, 'r')
      if f == nil then
        p.response:status(404)
        return 
      end
      pcall(function()
        local mimetypes = require('mimetypes')
        return p.response:set_options({
          ['Content-Type'] = mimetypes.guess(filename)
        })
      end)
      if #args and args[1].log then
        args[1].log:write(string.format('%s - [Static] Serving %s\n', os.date('%F %T', p.utils.now()), filename))
      end
      p.response:write(f:read('*a'))
      return false
    end
  end
end
return {
  Static = Static
}
