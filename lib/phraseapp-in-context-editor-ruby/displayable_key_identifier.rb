require 'phraseapp-in-context-editor-ruby/fallback_keys_fetcher'
require 'phraseapp-in-context-editor-ruby/key_names_cache'

module PhraseApp
  module InContextEditor
    class DisplayableKeyIdentifier
      attr_reader :api_wrapper, :key_names_cache

      def initialize(api_wrapper)
        @api_wrapper = api_wrapper
        @key_names_cache = KeyNamesCache.new(@api_wrapper)
      end

      def identify(key_name, options)
        fallback_key_names = FallbackKeysFetcher.extract_fallback_keys(key_name, options)
        return key_name if fallback_key_names.empty?

        key_names = [key_name] | fallback_key_names
        available_key_names = find_keys_within_phraseapp(key_names)

        key_names.each do |item|
          if available_key_names.include?(item)
            return item
          end
        end

        return key_name
      end

      private

      def find_keys_within_phraseapp(key_names)
        key_names_to_check_against_api = key_names - @key_names_cache.pre_fetched(key_names)
        @key_names_cache.pre_cached(key_names) | key_names_returned_from_api_for(key_names_to_check_against_api)
      end

      def key_names_returned_from_api_for(key_names)
        if key_names.size > 0
          api_wrapper.keys_by_names(key_names).map { |key| key.name }
        else
          []
        end
      end
    end
  end
end
