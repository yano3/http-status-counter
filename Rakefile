namespace :docker do
  desc "Run container for demo and development"
  task :run do
    local_path = File.dirname(__FILE__)
    sh "docker run --rm --name http-status-counter -v #{local_path}/docker/conf/nginx.conf:/etc/nginx/nginx.conf -v #{local_path}/status_counter:/etc/nginx/conf.d/status_counter -p 30080:80 yano3/nginx-ngx_mruby"
  end
end
