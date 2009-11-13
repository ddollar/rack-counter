require 'memcache'
require 'rack'

class Rack::Counter

  attr_reader :app, :options

  def initialize(app, options={})
    @app      = app
    @options  = options

    reset_stats! unless initialized?
  end

  def call(env)
    case env['PATH_INFO']
      when '/_stats.json'  then [200, {}, [stats.to_json]]
      when '/_stats/reset' then reset_stats!
      else                      record_hit!; app.call(env)
    end
  end

private

  def namespace
    options[:namespace] || 'rack-counter'
  end

  def memcache_host
    options[:memcache_host] || 'localhost:11211'
  end

## memcached #################################################################

  def memcache
    @memcache ||= MemCache.new(memcache_host, :namespace => namespace)
  end

  def initialized?
    memcache.get('hits', true)
  end

  def record_hit!
    memcache.incr('hits')
  end

  def reset_stats!
    memcache.set 'start', Time.now.utc
    memcache.set 'hits',  0, 0, true
  end

## stats #####################################################################

  def hits
    memcache.get('hits', true).to_i
  end

  def start
    memcache.get('start')
  end

  def average_hits_per_second
    '%0.4f' % (hits.to_f / (Time.now.utc - start))
  end

  def stats
    { 'hits' => hits, 'avg_per_sec' => average_hits_per_second }
  end

end
