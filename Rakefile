namespace :docker do
  desc "Build container for demo and development"
  task :build do
    sh "docker build -t local/http-status-counter ."
  end

  desc "Run container for demo and development"
  task :run => [:build] do
    local_path = File.dirname(__FILE__)
    sh "docker run -d -v #{local_path}/status_counter:/usr/local/nginx/status_counter -p 30080:80 local/http-status-counter"
  end
end
