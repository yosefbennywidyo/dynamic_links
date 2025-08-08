# frozen_string_literal: true

module DynamicLinks
  class StrategyFactory
    # Using a hash to map strategy names to their classes.
    STRATEGIES = {
      md5: ShorteningStrategies::MD5Strategy,
      sha256: ShorteningStrategies::SHA256Strategy,
      crc32: ShorteningStrategies::CRC32Strategy,
      nano_id: ShorteningStrategies::NanoIDStrategy,
      redis_counter: ShorteningStrategies::RedisCounterStrategy,
      mock: ShorteningStrategies::MockStrategy
    }.freeze

    def self.get_strategy(strategy_name)
      strategy_class = STRATEGIES[strategy_name]

      raise "Unknown strategy: #{strategy_name}" unless strategy_class

      strategy_class.new
    end
  end
end
