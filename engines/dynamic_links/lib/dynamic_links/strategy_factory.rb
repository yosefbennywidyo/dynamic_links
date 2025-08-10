# frozen_string_literal: true

module DynamicLinks
  class StrategyFactory
    VALID_SHORTENING_STRATEGIES = %i[md5 sha256 crc32
                                     nano_id redis_counter mock].freeze

    def self.get_strategy(strategy_name)
      strategy_class = DynamicLinks::Constants::STRATEGIES[strategy_name.to_sym]
      raise "Unknown strategy: #{strategy_name}" unless strategy_class
      strategy_class.new
    end
  end
end
