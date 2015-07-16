# -*- encoding : utf-8 -*-

require 'phraseapp-in-context-editor-ruby'

module PhraseApp
  module InContextEditor
    class Cache
      attr_accessor :lifetime

      def initialize(args={})
        @store = {}
        @lifetime = args.fetch(:lifetime, PhraseApp::InContextEditor.cache_lifetime)
      end

      def cached?(cache_key)
        @store.has_key?(cache_key) && !expired?(cache_key)
      end

      def get(cache_key)
        begin
          @store.fetch(cache_key)[:payload]
        rescue
          nil
        end
      end

      def set(cache_key, value)
        @store[cache_key] = {timestamp: Time.now, payload: value}
      end

    private
      def expired?(cache_key)
        @store.fetch(cache_key)[:timestamp] < (Time.now - @lifetime)
      end
    end
  end
end
