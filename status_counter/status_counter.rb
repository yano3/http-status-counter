Server = get_server_class
r = Server::Request.new
v = Server::Var.new
cache = Userdata.new.shared_cache

unless r.sub_request?
  st = StatusCounter.new cache
  st.update
end
