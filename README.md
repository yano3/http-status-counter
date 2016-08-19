# http-status-counter

Count and output sent http status code using mruby code.

## Configuration

### nginx

```nginx
http {
  mruby_init /path/to/nginx/conf.d/status_counter/status_counter_init.rb cache;

  server {
    location / {
      mruby_log_handler /path/to/nginx/conf.d/status_counter/status_counter.rb cache;
    }

    location /status_count {
      mruby_content_handler /path/to/nginx/conf.d/status_counter/status_counter_output.rb cache;
    }
  }
}
```

```shell
$ curl http://localhost/status_count
200:3344        301:1192        302:901 404:781
```

## use case

- [mackerel-plugin-http-status-counter](https://github.com/yano3/mackerel-plugin-http-status-counter)

## dependent mrbgem

```ruby
  conf.gem :github => 'matsumoto-r/mruby-localmemcache'
  conf.gem :github => 'matsumoto-r/mruby-mutex'
```
