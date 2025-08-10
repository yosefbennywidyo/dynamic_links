require 'dynamic_links/shortening_strategies/base_strategy'
require 'dynamic_links/shortening_strategies/sha256_strategy'
require 'dynamic_links/shortening_strategies/md5_strategy'
require 'dynamic_links/shortening_strategies/crc32_strategy'
require 'dynamic_links/shortening_strategies/nano_id_strategy'
require 'dynamic_links/shortening_strategies/redis_counter_strategy'
require 'dynamic_links/shortening_strategies/mock_strategy'

module DynamicLinks
  module Constants
    # A hash to map the filter values to the corresponding query objects.
    QUERY_STRATEGIES = {
      true => ->(query) { query.where("expires_at < ?", Time.current) },
      false => ->(query) { query.where("expires_at IS NULL OR expires_at >= ?", Time.current) }
    }.freeze

    SHORTENER_METHODS = {
      true => :shorten_async,
      false => :shorten
    }.freeze

    # Using a hash to map strategy names to their classes.
    STRATEGIES = {
      md5: ShorteningStrategies::MD5Strategy,
      sha256: ShorteningStrategies::SHA256Strategy,
      crc32: ShorteningStrategies::CRC32Strategy,
      nano_id: ShorteningStrategies::NanoIDStrategy,
      redis_counter: ShorteningStrategies::RedisCounterStrategy,
      mock: ShorteningStrategies::MockStrategy
    }.freeze

    STORAGE_OPERATIONS = {
      true => ->(storage, client, url, short_url) { storage.create!(client: client, url: url, short_url: short_url) },
      false => ->(storage, client, url, short_url) { storage.find_or_create!(client, short_url, url) }
    }.freeze
  end
end
