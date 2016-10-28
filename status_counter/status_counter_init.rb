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
    @interval = 60
  end

  def update
    v = Server::Var.new

    stats = current_stats

    stats[:requests] += 1

    status_code = v.status.to_s
    status_counts = stats[:status]
    status_counts[status_code.to_sym] ||= 0
    status_counts[status_code.to_sym] = status_counts[status_code.to_sym] + 1
    stats[:status] = status_counts

    body_bytes_sent = v.body_bytes_sent.to_i
    stats[:body_bytes_sent] += body_bytes_sent

    request_time = (v.request_time.to_f * 1000).to_i
    stats[:request_time] += request_time

    if @cache["period_statistics"]
      period_statistics = eval(@cache["period_statistics"])
    else
      period_statistics = init_period_statistics
    end

    # calc average response time
    if Time.now.to_i - period_statistics[:updated] > @interval
      avg_request_time = nil
      if period_statistics[:requests].to_i > 0
        avg_request_time = period_statistics[:request_time] / period_statistics[:requests]
      end

      stats[:avg_request_time] = avg_request_time
      period_statistics[:updated] = Time.now.to_i
      period_statistics = init_period_statistics
    end

    period_statistics[:requests] += 1
    period_statistics[:request_time] += request_time

    @cache["period_statistics"] = period_statistics.to_s
    @cache["stats"] = stats.to_s
  end

  def init_period_statistics
    {
      requests: 0,
      request_time: 0,
      updated: Time.now.to_i,
    }
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
        requests: 0,
        status: { },
        body_bytes_sent: 0,
        request_time: 0,
        avg_request_time: nil,
      }
    end
  end
end
