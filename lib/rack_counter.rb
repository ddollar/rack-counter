require 'memcache'
require 'rack'

class Rack::Counter

  attr_reader :app, :options

  def initialize(app, options={})
    @app      = app
    @options  = options

    memcache.add 'start', Time.now
    memcache.add 'hits',  0, 0, true
  end

  def call(env)
    case env['PATH_INFO']
      when '/_stats.json'  then [200, {}, [stats.to_json]]
      when '/_stats/reset' then reset_stats!
      else                      record_hit!; app.call(env)
    end
  end

private ######################################################################

  def namespace
    options[:namespace] || 'rack-counter'
  end

  def memcache_host
    options[:memcache_host] || 'localhost:11211'
  end

  def memcache
    @memcache ||= MemCache.new(memcache_host, :namespace => namespace)
  end

  def record_hit!
    memcache.incr('hits')
  end

  def reset_stats!
    memcache.replace 'start', Time.now
    memcache.replace 'hits', 0, 0, true
  end

  def stats
    {
      'hits' => memcache.get('hits', true).to_i
    }
  end

end
