local validate_handler
do
  local _obj_0 = require("gimlet.utils")
  validate_handler = _obj_0.validate_handler
end
local Route
do
  local _base_0 = {
    validate = function(self)
      local _list_0 = self.handlers
      for _index_0 = 1, #_list_0 do
        local h = _list_0[_index_0]
        validate_handler(h)
      end
    end,
    match_method = function(self, method)
      return self.method == '*' or method == self.method or (method == 'HEAD' and self.method == 'GET')
    end,
    match = function(self, method, path)
      if not (self:match_method(method)) then
        return nil
      end
      local matches = {
        string.find(path, self.str_match)
      }
      if #matches > 0 and string.sub(path, matches[1], matches[2]) == path then
        local _tbl_0 = { }
        for i, match in ipairs(matches) do
          if i > 2 then
            _tbl_0[self.params[i - 2]] = match
          end
        end
        return _tbl_0
      end
      return nil
    end,
    handle = function(self, mapped)
      local _list_0 = self.handlers
      for _index_0 = 1, #_list_0 do
        local handler = _list_0[_index_0]
        local options, output = handler(mapped)
        if type(options) == 'string' then
          mapped.response:write(options)
        else
          if type(options) == 'table' then
            mapped.response:set_options(options)
          end
          if type(options) == 'number' then
            mapped.response:status(options)
          end
          if type(output) == 'string' then
            mapped.response:write(output)
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, method, pattern, handlers)
      self.method = method
      self.pattern = pattern
      self.handlers = handlers
      local tmp_params = { }
      local tmp_params_max = 0
      for i, n in string.gmatch(pattern, '():([^/#?]+)') do
        tmp_params[i] = n
        if i > tmp_params_max then
          tmp_params_max = i
        end
      end
      local idx = 1
      for i in string.gmatch(pattern, '()%*%*') do
        tmp_params[i] = idx
        if i > tmp_params_max then
          tmp_params_max = i
        end
        idx = idx + 1
      end
      local empty = { }
      for i = 1, tmp_params_max do
        if tmp_params[i] == nil then
          tmp_params[i] = empty
        end
      end
      do
        local _accum_0 = { }
        local _len_0 = 1
        for _index_0 = 1, #tmp_params do
          local n = tmp_params[_index_0]
          if n ~= empty then
            _accum_0[_len_0] = n
            _len_0 = _len_0 + 1
          end
        end
        self.params = _accum_0
      end
      self.str_match = string.gsub(pattern, '[-.]', '%%%1')
      self.str_match = self.str_match .. "/?"
      self.str_match = string.gsub(self.str_match, ':([^/#?]+)', '([^/#?]+)')
      self.str_match = string.gsub(self.str_match, '(%*%*)', '([^#?]*)')
    end,
    __base = _base_0,
    __name = "Route"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Route = _class_0
end
local Router
do
  local _base_0 = {
    add_route = function(self, method, pattern, handler)
      if #self.groups > 0 then
        local group_pattern = ""
        local h = { }
        local _list_0 = self.groups
        for _index_0 = 1, #_list_0 do
          local g = _list_0[_index_0]
          group_pattern = group_pattern .. g.pattern
          table.insert(h, g.handler)
        end
        pattern = group_pattern .. pattern
        table.insert(h, handler)
        handler = h
      end
      if not (type(handler) == 'table') then
        handler = {
          handler
        }
      end
      local route = Route(method, pattern, handler)
      route:validate()
      table.insert(self.routes, route)
      return route
    end,
    group = function(self, pattern, fn, handler)
      table.insert(self.groups, {
        pattern = pattern,
        handler = handler
      })
      return fn(self)
    end,
    get = function(self, pattern, handler)
      return self:add_route('GET', pattern, handler)
    end,
    post = function(self, pattern, handler)
      return self:add_route('POST', pattern, handler)
    end,
    put = function(self, pattern, handler)
      return self:add_route('PUT', pattern, handler)
    end,
    delete = function(self, pattern, handler)
      return self:add_route('DELETE', pattern, handler)
    end,
    patch = function(self, pattern, handler)
      return self:add_route('PATCH', pattern, handler)
    end,
    options = function(self, pattern, handler)
      return self:add_route('OPTIONS', pattern, handler)
    end,
    head = function(self, pattern, handler)
      return self:add_route('HEAD', pattern, handler)
    end,
    any = function(self, pattern, handler)
      return self:add_route('ANY', pattern, handler)
    end,
    not_found = function(self, ...)
      self.not_founds = {
        ...
      }
    end,
    handle = function(self, mapped, method, path)
      local _list_0 = self.routes
      for _index_0 = 1, #_list_0 do
        local route = _list_0[_index_0]
        local params = route:match(method, path)
        if params then
          mapped.params = params
          route:handle(mapped)
          return 
        end
      end
      mapped.response:status(404)
      local _list_1 = self.not_founds
      for _index_0 = 1, #_list_1 do
        local h = _list_1[_index_0]
        if type(h) == 'function' then
          local r = h(mapped, method, path)
          if type(r) == 'string' then
            mapped.response:write(r)
          end
          return 
        end
      end
      return mapped.response:write("Not found")
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.routes = { }
      self.groups = { }
      self.not_founds = { }
    end,
    __base = _base_0,
    __name = "Router"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Router = _class_0
end
return {
  Route = Route,
  Router = Router
}
