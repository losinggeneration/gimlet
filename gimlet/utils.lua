local validate_handler
validate_handler = function(handler)
  if type(handler) ~= "function" then
    return error("Gimlet handler must be a function")
  end
end
return {
  validate_handler = validate_handler
}
