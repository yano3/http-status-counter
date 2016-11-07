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
$ curl http://localhost/status_count | jq
{
  "requests": 6218,
  "status": {
    "200": 3344,
    "301": 1192,
    "302": 901,
    "404": 781
  },
  "body_bytes_sent": 5200307169,
  "request_time": 379091,
  "avg_request_time": 61.084822695035,
  "upstream_response_time": 351707,
  "avg_upstream_response_time": 57.210212765957
}
```

## use case

- [mackerel-plugin-http-status-counter](https://github.com/yano3/mackerel-plugin-http-status-counter)

## dependent mrbgem

```ruby
  conf.gem :github => 'matsumotory/mruby-localmemcache'
  conf.gem :github => 'matsumotory/mruby-mutex'
  conf.gem :github => 'mattn/mruby-json'
```
