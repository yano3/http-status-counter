config = {:namespace =>"status_counter"}

c = Cache.new config
c.clear

Userdata.new.shared_cache = c
