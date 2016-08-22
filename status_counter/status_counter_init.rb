Server = get_server_class
Userdata.new.shared_mutex = Mutex.new :global => true

config = {
  namespace: "status_counter",
  size_mb: 32,
}

Userdata.new.shared_cache = Cache.new config

class StatusCounter
  def initialize c
    @cache = c
  end

  def update
    v = Server::Var.new
    status = v.status.to_s
    stats = current_stats

    stats[status.to_sym] ||= 0
    stats[status.to_sym] = stats[status.to_sym] + 1

    @cache["stats"] = stats.to_s
  end

  def output
    out = JSON::stringify({
      "status" => current_stats.sort.to_h
    })
    Server.echo out
  end

  def current_stats
    if @cache["stats"]
      eval(@cache["stats"])
    else
      {}
    end
  end
end
