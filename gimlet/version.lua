local major, minor, patch, dev = 0, 1, 0, nil
local version = string.format("%s.%s.%s", major, minor, (function()
  if dev then
    return patch .. dev
  else
    return patch
  end
end)())
return {
  version = version,
  major = major,
  minor = minor,
  patch = patch
}
