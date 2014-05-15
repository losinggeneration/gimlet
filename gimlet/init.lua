local dispatch
do
  local _obj_0 = require("gimlet.dispatcher")
  dispatch = _obj_0.dispatch
end
local gimlet_cache = { }
local runner
runner = function(gimlet_cls)
  local gimlet = gimlet_cache[gimlet_cls]
  if not (gimlet) then
    if type(gimlet_cls) == "string" then
      gimlet = require(gimlet_cls)()
    elseif gimlet_cls.__base then
      gimlet = gimlet_cls()
    else
      gimlet = gimlet_cls
    end
    gimlet_cache[gimlet_cls] = gimlet
  end
  return dispatch(gimlet)
end
local mixin
mixin = function(self, cls, ...)
  for key, val in pairs(cls.__base) do
    if not key:match("^__") then
      self[key] = val
    end
  end
  return cls.__init(self, ...)
end
local Logger
do
  local _obj_0 = require("gimlet.logger")
  Logger = _obj_0.Logger
end
local Router
do
  local _obj_0 = require("gimlet.router")
  Router = _obj_0.Router
end
local Static
do
  local _obj_0 = require("gimlet.static")
  Static = _obj_0.Static
end
local validate_handler
do
  local _obj_0 = require("gimlet.utils")
  validate_handler = _obj_0.validate_handler
end
local Gimlet
do
  local _base_0 = {
    handlers = function(self, ...)
      self._handlers = { }
      for _, h in pairs({
        ...
      }) do
        self:use(h)
      end
    end,
    set_action = function(self, handler)
      validate_handler(handler)
      self.action = handler
    end,
    use = function(self, handler)
      validate_handler(handler)
      return table.insert(self._handlers, handler)
    end,
    map = function(self, name, value)
      self._mapped[name] = value
    end,
    run = function(self)
      return runner(self)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.action = function(self) end
      self._handlers = { }
      self._mapped = {
        gimlet = self
      }
    end,
    __base = _base_0,
    __name = "Gimlet"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Gimlet = _class_0
end
local Classic
do
  local _base_0 = { }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, log)
      if log == nil then
        log = io.stdout
      end
      mixin(self, Gimlet)
      mixin(self, Router)
      self:use(Logger(log))
      self:use(Static("/public", {
        log = log
      }))
      return self:set_action(self.handle)
    end,
    __base = _base_0,
    __name = "Classic"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Classic = _class_0
end
return {
  Gimlet = Gimlet,
  Classic = Classic
}
