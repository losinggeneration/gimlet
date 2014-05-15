major, minor, patch, dev = 0, 1, 0, "-dev"
version = string.format "%s.%s.%s", major, minor, if dev then patch .. dev else patch

{ :version, :major, :minor, :patch }
