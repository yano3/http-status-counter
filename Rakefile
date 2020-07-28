namespace :docker do
  desc "Run container for demo and development"
  task :run do
    local_path = File.dirname(__FILE__)
    sh "docker run --rm -d -v #{local_path}/docker/conf/nginx.conf:/usr/local/nginx/conf/nginx.conf -v #{local_path}/status_counter:/usr/local/nginx/status_counter -p 30080:80 matsumotory/docker-ngx_mruby"
  end
end
