module Influxer
  # - Overriding loggging (use instrumentation and Rails logger)
  # - Add cache support for queries
  class Client
    def query(sql, options = {})
      log(sql) do
        if !options.fetch(:cache, true) || Influxer.config.cache == false
          super(sql, options)
        else
          Rails.cache.fetch(normalized_cache_key(sql), cache_options(sql)) { super(sql, options) }
        end
      end
    end

    def log(sql)
      return yield unless logger.debug?

      start_ts = Time.now
      res = yield
      duration = (Time.now - start_ts) * 1000

      name = "InfluxDB SQL (#{duration.round(1)}ms)"

      # bold black name and blue query string
      msg = "\e[1m\e[30m#{name}\e[0m  \e[34m#{sql}\e[0m"
      logger.debug msg
      res
    end

    # if sql contains 'now()' set expires to 1 minute or :cache_now_for value
    # of config.cache if defined
    def cache_options(sql = nil)
      options = Influxer.config.cache.dup
      options[:expires_in] = (options[:cache_now_for] || 60) if sql =~ /\snow\(\)/
      options
    end

    # add prefix; remove whitespaces
    def normalized_cache_key(sql)
      "influxer:#{sql.gsub(/\s*/, '')}"
    end

    def logger
      Rails.logger
    end
  end
end
