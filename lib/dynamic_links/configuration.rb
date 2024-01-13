module DynamicLinks
  # @author Saiqul Haq <saiqulhaq@gmail.com>

  class Configuration
    attr_accessor :shortening_strategy, :enable_rest_api, :db_infra_strategy,
                  :async_processing, :redis_counter_config, :cache_store_config

    DEFAULT_SHORTENING_STRATEGY = :MD5
    DEFAULT_ENABLE_REST_API = true
    DEFAULT_DB_INFRA_STRATEGY = :standard
    DEFAULT_ASYNC_PROCESSING = false
    DEFAULT_REDIS_COUNTER_CONFIG = RedisConfig.new
    DEFAULT_CACHE_STORE_CONFIG = { type: nil, redis_config: {}, memcached_config: {} }

    # Usage:
    #     DynamicLinks.configure do |config|
    #       config.shortening_strategy = :MD5 # or other strategy name, see StrategyFactory for available strategies
    #       config.enable_rest_api = true # or false. when false, the API requests will be rejected
    #       config.db_infra_strategy = :standard # or :sharding. if sharding is used, then xxx
    #       config.async_processing = false # or true. if true, the shortening process will be done asynchronously using ActiveJob
    #       config.redis_counter_config = RedisConfig.new # see RedisConfig documentation for more details
    #       # if you use Redis
    #       config.cache_store_config = { type: :redis, redis_config: { host: 'localhost', port: 6379 } }
    #       # if you use Memcached
    #       config.cache_store_config = { type: :memcached, memcached_config: { host: 'localhost', port: 6379 } }
    #     end
    #
    # @return [Configuration]
    def initialize
      @shortening_strategy = DEFAULT_SHORTENING_STRATEGY
      @enable_rest_api = DEFAULT_ENABLE_REST_API
      @db_infra_strategy = DEFAULT_DB_INFRA_STRATEGY
      @async_processing = DEFAULT_ASYNC_PROCESSING

      # config for RedisCounterStrategy
      @redis_counter_config = DEFAULT_REDIS_COUNTER_CONFIG
      @cache_store_config = DEFAULT_CACHE_STORE_CONFIG
    end

    def cache_store_enabled?
      [:redis, :memcached].include?(@cache_store_config[:type])
    end

    def cache_store
      @cache_store ||= begin
                         unless cache_store_enabled?
                           raise ConfigurationError, 'Cache store is not configured'
                         end

                         case cache_store_config[:type]
                         when :redis
                           create_redis_cache_store(cache_store_config[:redis_config])
                         when :memcached
                           create_memcached_cache_store(cache_store_config[:memcached_config])
                         else
                           raise DynamicLinks::UnknownCacheStoreType, "Unsupported cache store type: #{cache_store_config[:type]}"
                         end
                       end
    end

    private

    def create_redis_cache_store(config)
      require 'redis'
      DynamicLinks::RedisCacheStore.new(config)
    rescue LoadError
      raise DynamicLinks::MissingDependency, "Please install the 'redis' gem to use Redis as cache store"
    end

    def create_memcached_cache_store(config)
      DynamicLinks::MemcachedCacheStore.new(config)
    rescue LoadError
      raise DynamicLinks::MissingDependency, "Please install the 'memcached' gem to use Memcached as cache store"
    end
  end
end
