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
    upstream_response_time = (v.upstream_response_time.to_f * 1000).to_i
    stats[:upstream_response_time] += upstream_response_time

    # calculate latency
    if Time.now.to_i - stats[:period_updated] > @interval
      if stats[:period_requests].to_i > 0
        avg_request_time = stats[:period_request_time] / stats[:period_requests]
        avg_upstream_response_time = stats[:period_upstream_response_time] / stats[:period_requests]
        stats[:avg_request_time] = avg_request_time
        stats[:avg_upstream_response_time] = avg_upstream_response_time
        stats[:period_requests] = 0
        stats[:period_request_time] = 0
        stats[:period_upstream_response_time] = 0
        stats[:period_updated] = Time.now.to_i
      end
    end

    if status_code.to_i >= 200 && status_code.to_i < 300
      stats[:period_requests] += 1
      stats[:period_request_time] += request_time
      stats[:period_upstream_response_time] += upstream_response_time
    end

    @cache["stats"] = stats.to_s
  end

  def output
    stats = current_stats
    stats[:status] = stats[:status].sort.to_h

    if Time.now.to_i - stats[:period_updated] > 300
      stats[:avg_request_time] = nil
    end

    out = {
      requests: stats[:requests],
      status: stats[:status],
      body_bytes_sent: stats[:body_bytes_sent],
      request_time: stats[:request_time],
      avg_request_time: stats[:avg_request_time],
      upstream_response_time: stats[:upstream_response_time],
      avg_upstream_response_time: stats[:avg_upstream_response_time]
    }

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
        upstream_response_time: 0,
        avg_request_time: nil,
        period_requests: 0,
        period_request_time: 0,
        period_upstream_response_time: 0,
        period_updated: Time.now.to_i
      }
    end
  end
end
