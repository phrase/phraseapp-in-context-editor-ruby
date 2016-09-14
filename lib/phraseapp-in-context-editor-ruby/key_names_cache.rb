module PhraseApp
  module InContextEditor
    class KeyNamesCache
      attr_reader :api_wrapper

      def initialize(api_wrapper)
        @api_wrapper = api_wrapper
      end

      def pre_cached(key_names)
        unless cache.cached?(:translation_key_names)
          cache.set(:translation_key_names, prefetched_key_names)
        end

        return key_names.select { |key_name| key_name_precached?(key_name) }
      end

      def pre_fetched(key_names)
        key_names.select { |key_name| covered_by_initial_caching?(key_name) }
      end

      private

      def prefetched_key_names
        prefetched = Set.new
        PhraseApp::InContextEditor.cache_key_segments_initial.each do |prefix|
          api_wrapper.keys_with_prefix(prefix).each do |key|
            prefetched.add(key.name)
          end
        end
        prefetched
      end

      def covered_by_initial_caching?(key_name)
        key_name.start_with?(*PhraseApp::InContextEditor.cache_key_segments_initial)
      end

      def key_name_is_in_cache?(key_name)
        cache.get(:translation_key_names).include?(key_name)
      end

      def key_name_precached?(key_name)
        covered = covered_by_initial_caching?(key_name)
        in_cache = key_name_is_in_cache?(key_name)
        return covered && in_cache
      end

      def cache
        Thread.current[:phraseapp_cache] ||= PhraseApp::InContextEditor::Cache.new
      end
    end
  end
end
