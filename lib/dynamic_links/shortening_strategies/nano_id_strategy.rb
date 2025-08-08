module DynamicLinks
  module ShorteningStrategies
    # Shortens the given URL using Nano ID
    # This strategy will generate a different short URL for the same given URL
    class NanoIDStrategy < BaseStrategy
      def initialize
        require 'nanoid'
      rescue LoadError
        raise 'Missing dependency: Please add "nanoid" to your Gemfile.'
      end
      # Shortens the given URL using Nano ID
      # @param url [String] The URL to shorten (not directly used in Nano ID strategy)
      # @param min_length [Integer] The size (length) of the generated Nano ID
      def shorten(url, min_length: MIN_LENGTH)
        ::Nanoid.generate(size: min_length)
      end

      def always_growing?
        true  # This strategy always generates a new shortened URL
      end
    end
  end
end

