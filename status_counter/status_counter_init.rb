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

    stats = current_stats

    status_code = v.status.to_s
    status_counts = stats[:status]
    status_counts[status_code.to_sym] ||= 0
    status_counts[status_code.to_sym] = status_counts[status_code.to_sym] + 1
    stats[:status] = status_counts

    body_bytes_sent = v.body_bytes_sent.to_i
    stats[:body_bytes_sent] += body_bytes_sent

    @cache["stats"] = stats.to_s
  end

  def output
    out = current_stats
    out[:status] = out[:status].sort.to_h
    Server.echo JSON::stringify(out)
  end

  def current_stats
    if @cache["stats"]
      eval(@cache["stats"])
    else
      {
        status: { },
        body_bytes_sent: 0,
      }
    end
  end
end
