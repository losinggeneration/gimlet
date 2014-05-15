local dispatch
dispatch = function(gimlet)
  local wsapi_run
  wsapi_run = function(env)
    local headers = nil
    if not (gimlet.content_type) then
      headers = {
        ["Content-Type"] = "text/html"
      }
    else
      headers = {
        ["Content-Type"] = gimlet.content_type
      }
    end
    local wsapi_request = require("wsapi.request")
    local wsapi_response = require("wsapi.response")
    local wsapi_util = require("wsapi.util")
    local req = wsapi_request.new(env)
    local res = wsapi_response.new(200, headers)
    local resWrap
    do
      local _base_0 = {
        write = function(self, ...)
          return res:write(...)
        end,
        set_options = function(self, options)
          if options["Content-Type"] then
            headers["Content-Type"] = options["Content-Type"]
          end
          if not (options.headers == nil) then
            for k, v in pairs(options.headers) do
              headers[k] = v
            end
          end
          if not (options.status == nil) then
            return self:status(options.status)
          end
        end,
        status = function(self, s)
          if not (s == nil) then
            res.status = s
          end
          return res.status
        end
      }
      _base_0.__index = _base_0
      local _class_0 = setmetatable({
        __init = function() end,
        __base = _base_0,
        __name = "resWrap"
      }, {
        __index = _base_0,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      resWrap = _class_0
    end
    local reqWrap
    do
      local _base_0 = { }
      _base_0.__index = _base_0
      local _class_0 = setmetatable({
        __init = function(self)
          self.url_path = req.path_info
          self.query_params = req.GET
          self.request_uri = req.path_info .. '/' .. req.query_string
          self.method = req.method
          self.post_args = { }
          if self.method == 'POST' then
            self.post_args = req.POST
          end
        end,
        __base = _base_0,
        __name = "reqWrap"
      }, {
        __index = _base_0,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      reqWrap = _class_0
    end
    local util
    do
      local _base_0 = {
        now = function()
          return os.time()
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
    local request = reqWrap()
    local response = resWrap()
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
      gimlet:action(mapped, req.method, req.path_info)
    end
    local c = true
    while c do
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
    return res:finish()
  end
  if gimlet.cgi then
    local run
    do
      local _obj_0 = require("wsapi.cgi")
      run = _obj_0.run
    end
    return run(wsapi_run)
  elseif gimlet.fcgi then
    local run
    do
      local _obj_0 = require("wsapi.fastcgi")
      run = _obj_0.run
    end
    return run(wsapi_run)
  end
  return {
    run = wsapi_run
  }
end
return {
  dispatch = dispatch
}
