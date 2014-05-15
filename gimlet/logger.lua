local ft
ft = function(t)
  return os.date("%F %T", t)
end
local Logger
Logger = function(log)
  return function(p)
    local start = p.utils.now()
    log:write(string.format("%s - Started %s %s\n", ft(start), p.request.method, p.request.url_path))
    p = coroutine.yield()
    return log:write(string.format("%s - Completed %s %s (%d) in %.4f seconds\n", ft(p.utils.now()), p.request.method, p.request.url_path, p.response:status(), p.utils.now() - start))
  end
end
return {
  Logger = Logger
}
