# http-status-counter

Count and output sent http status code using mruby code.

## Configuration

### nginx

```nginx
http {
  mruby_init /path/to/nginx/conf.d/status_counter/status_counter_init.rb;
  mruby_init_worker /path/to/nginx/conf.d/status_counter/status_counter_worker_init.rb;

  server {
    location / {
      mruby_log_handler /path/to/nginx/conf.d/status_counter/status_counter.rb;
    }

    location /status_counter {
      mruby_content_handler /path/to/nginx/conf.d/status_counter/status_counter_output.rb;
    }
  }
}
```

## dependent mrbgem

```ruby
  conf.gem :github => 'matsumoto-r/mruby-localmemcache'
```
