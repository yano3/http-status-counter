config = {
  namespace: "status_counter",
  size_mb: 32,
}

c = Cache.new config
c.clear

Userdata.new.shared_cache = c
