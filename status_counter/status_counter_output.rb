cache = Userdata.new.shared_cache
mutex = Userdata.new.shared_mutex

timeout = mutex.try_lock_loop(50000) do
  st = StatusCounter.new cache
  begin
    st.output
  rescue => e
    raise "http-status-counter: #{e}"
  ensure
    mutex.unlock
  end
end
if timeout
  Server.errlogger Server::LOG_NOTICE, "http-status-counter: mutex lock timeout"
end
