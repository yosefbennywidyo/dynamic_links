# frozen_string_literal: true

module DynamicLinks
  class StrategyFactory
    # Using a hash to map strategy names to their classes.
    STRATEGIES = {
      md5: ShorteningStrategies::MD5,
      sha256: ShorteningStrategies::SHA256,
      crc32: ShorteningStrategies::CRC32,
      nano_id: ShorteningStrategies::NanoID,
      redis_counter: ShorteningStrategies::RedisCounter,
      mock: ShorteningStrategies::Mock
    }.freeze

    def self.get_strategy(strategy_name)
      strategy_class = STRATEGIES[strategy_name]

      raise "Unknown strategy: #{strategy_name}" unless strategy_class

      strategy_class.new
    end
  end
end
