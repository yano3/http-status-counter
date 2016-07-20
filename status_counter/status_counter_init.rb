Server = get_server_class

class StatusCounter
  def initialize c
    @cache = c
  end

  def update
    v = Server::Var.new
    status = v.status

    stats = current_stats

    stats[status.to_sym] = (stats[status.to_sym].to_i + 1).to_s
    @cache["stats"] = stats.to_s
  end

  def output
    out = current_stats.sort.map{|key,value| "#{key}:#{value}"}.join("\t")
    Server.echo "#{out}"
  end

  def current_stats
    stats = @cache["stats"]
    if stats == nil then
      {}
    else
      eval(stats)
    end
  end
end
