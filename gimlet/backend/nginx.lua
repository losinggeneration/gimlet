local dispatch
dispatch = function(gimlet)
  if not (gimlet.content_type) then
    ngx.header["Content-Type"] = "text/html"
  else
    ngx.header["Content-Type"] = gimlet.content_type
  end
  local res
  do
    local _base_0 = {
      write = function(self, ...)
        return ngx.print(...)
      end,
      set_options = function(self, options)
        if options["Content-Type"] then
          ngx.header["Content-Type"] = options["Content-Type"]
        end
        if not (options.headers == nil) then
          for k, v in pairs(options.headers) do
            ngx.headers[k] = v
          end
        end
        if not (options.status == nil) then
          return self:status(options.status)
        end
      end,
      status = function(self, s)
        if not (s == nil) then
          ngx.status = s
        end
        return ngx.status
      end
    }
    _base_0.__index = _base_0
    local _class_0 = setmetatable({
      __init = function() end,
      __base = _base_0,
      __name = "res"
    }, {
      __index = _base_0,
      __call = function(cls, ...)
        local _self_0 = setmetatable({}, _base_0)
        cls.__init(_self_0, ...)
        return _self_0
      end
    })
    _base_0.__class = _class_0
    res = _class_0
  end
  local req
  do
    local _base_0 = { }
    _base_0.__index = _base_0
    local _class_0 = setmetatable({
      __init = function(self)
        self.url_path = ngx.var.uri
        self.request_uri = ngx.var.request_uri
        self.query_params = ngx.req.get_uri_args()
        self.method = ngx.req.get_method()
        self.post_args = { }
        if self.method == 'POST' then
          ngx.req.read_body()
          self.post_args = ngx.req.get_post_args()
        end
      end,
      __base = _base_0,
      __name = "req"
    }, {
      __index = _base_0,
      __call = function(cls, ...)
        local _self_0 = setmetatable({}, _base_0)
        cls.__init(_self_0, ...)
        return _self_0
      end
    })
    _base_0.__class = _class_0
    req = _class_0
  end
  local util
  do
    local _base_0 = {
      now = function()
        return ngx.now()
      end
    }
    _base_0.__index = _base_0
    local _class_0 = setmetatable({
      __init = function() end,
      __base = _base_0,
      __name = "util"
    }, {
      __index = _base_0,
      __call = function(cls, ...)
        local _self_0 = setmetatable({}, _base_0)
        cls.__init(_self_0, ...)
        return _self_0
      end
    })
    _base_0.__class = _class_0
    util = _class_0
  end
  local request = req()
  local response = res()
  local utils = util()
  local mapped
  do
    local _with_0 = gimlet._mapped
    _with_0.request = request
    _with_0.response = response
    _with_0.utils = utils
    mapped = _with_0
  end
  local coros
  do
    local _accum_0 = { }
    local _len_0 = 1
    local _list_0 = gimlet._handlers
    for _index_0 = 1, #_list_0 do
      local middleware = _list_0[_index_0]
      _accum_0[_len_0] = coroutine.create(middleware)
      _len_0 = _len_0 + 1
    end
    coros = _accum_0
  end
  local finish
  for _index_0 = 1, #coros do
    local middleware = coros[_index_0]
    if finish then
      coroutine.resume(middleware, mapped)
    else
      local _
      _, finish = coroutine.resume(middleware, mapped)
    end
  end
  if not (finish == false) then
    gimlet:action(mapped, request.method, request.url_path)
  end
  local c = true
  while c do
    ngx.update_time()
    c = false
    for _index_0 = 1, #coros do
      local middleware = coros[_index_0]
      local _exp_0 = coroutine.status(middleware)
      if "suspended" == _exp_0 then
        coroutine.resume(middleware, mapped)
        c = true
      end
    end
  end
  return response:status()
end
return {
  dispatch = dispatch
}
