# -*- encoding : utf-8 -*-

require 'phraseapp-in-context-editor-ruby/cache'
require 'phraseapp-in-context-editor-ruby/hash_flattener'
require 'phraseapp-in-context-editor-ruby/delegate'
require 'phraseapp-in-context-editor-ruby/api_wrapper'
require 'set'

module PhraseApp
  module InContextEditor
    module Delegate
      class I18n < Base
        attr_accessor :key, :display_key, :options, :api_client, :fallback_keys, :original_args

        def initialize(key, options={}, original_args=nil)
          @display_key = @key = key
          @options = options
          @original_args = original_args

          @fallback_keys = []

          extract_fallback_keys
          identify_key_to_display if @fallback_keys.any?
          super(decorated_key_name)
        end

        def method_missing(*args, &block)
          self.class.log "Trying to execute missing method ##{args.first} on key #{@key}"
          if @key.respond_to?(args.first)
            to_s.send(*args)
          else
            data = translation_or_subkeys
            if data.respond_to?(args.first)
              data.send(*args, &block)
            else
              self.class.log "You tried to execute the missing method ##{args.first} on key #{@key} which is not supported. Please make sure you treat your translations as strings only."
              original_translation = ::I18n.translate_without_phraseapp(*@original_args)
              original_translation.send(*args, &block)
            end
          end
        end

      private
        def identify_key_to_display
          key_names = [@key] | @fallback_keys
          available_key_names = find_keys_within_phraseapp(key_names)
          @display_key = @key
          key_names.each do |item|
            if available_key_names.include?(item)
              @display_key = item
              break
            end
          end
        end

        def find_keys_within_phraseapp(key_names)
          key_names_to_check_against_api = key_names - pre_fetched(key_names)
          pre_cached(key_names) | key_names_returned_from_api_for(key_names_to_check_against_api)
        end

        def pre_cached(key_names)
          warm_translation_key_names_cache unless cache.cached?(:translation_key_names)
          pre_cached_key_names = key_names.select { |key_name| key_name_precached?(key_name) }
          pre_cached_key_names
        end

        def pre_fetched(key_names)
          key_names.select { |key_name| covered_by_initial_caching?(key_name) }
        end

        def key_name_precached?(key_name)
          covered = covered_by_initial_caching?(key_name)
          in_cache = key_name_is_in_cache?(key_name)
          covered && in_cache
        end

        def key_names_returned_from_api_for(key_names)
          if key_names.size > 0
            api_wrapper.keys_by_names(key_names).map{ |key| key.name }
          else
            []
          end
        end

        def key_name_is_in_cache?(key_name)
          cache.get(:translation_key_names).include?(key_name)
        end

        def covered_by_initial_caching?(key_name)
          key_name.start_with?(*PhraseApp::InContextEditor.cache_key_segments_initial)
        end

        def extract_fallback_keys
          fallback_items = []
          if @options.has_key?(:default)
            if @options[:default].kind_of?(Array)
              fallback_items = @options[:default]
            else
              fallback_items << @options[:default]
            end
          end

          fallback_items.each do |item|
            process_fallback_item(item)
          end
        end

        def scoped(item)
          @options.has_key?(:scope) ? "#{@options[:scope]}.#{item}" : item
        end

        def process_fallback_item(item)
          if item.kind_of?(Symbol)
            entry = scoped(item.to_s)
            @fallback_keys << entry
            if @key == "helpers.label.#{entry}" # http://apidock.com/rails/v3.1.0/ActionView/Helpers/FormHelper/label
              @fallback_keys << "activerecord.attributes.#{entry}"
            end

            if @key.start_with?("simple_form.") # special treatment for simple form
              @fallback_keys << "activerecord.attributes.#{item.to_s}"
            end
          end
        end

        def translation_or_subkeys
          keys = api_wrapper.keys_with_prefix(@key)
          return nil unless keys.present?

          if keys.size == 1
            translation_content_for_key(keys.first)
          else
            translation_hash = keys.inject({}) do |hash, key|
              hash[key.name] = translation_content_for_key(key)
              hash
            end

            PhraseApp::InContextEditor::HashFlattener.expand_flat_hash(translation_hash, @key)
          end
        end

        def cache
          Thread.current[:phraseapp_cache] ||= build_cache
        end

        def build_cache
          cache = PhraseApp::InContextEditor::Cache.new
        end

        def warm_translation_key_names_cache
          cache.set(:translation_key_names, prefetched_key_names)
        end

        def prefetched_key_names
          prefetched = Set.new
          PhraseApp::InContextEditor.cache_key_segments_initial.each do |prefix|
            api_wrapper.keys_with_prefix(prefix).each do |key|
              prefetched.add(key.name)
            end
          end
          prefetched
        end

        def key_names_from_nested(segment, data)
          key_names = Set.new
          PhraseApp::InContextEditor::HashFlattener.flatten(data, nil) do |key, value|
            key_names.add("#{segment}.#{key}") unless value.is_a?(Hash)
          end unless (data.is_a?(String) || data.nil?)
          key_names
        end

        def translation_content_for_key(key)
          default_translations = api_wrapper.default_translation(key)
          return unless default_translations.present?

          if key.plural
            default_translations.inject({}) do |hash, translation|
              hash[translation.plural_suffix.to_sym] = translation.content
              hash
            end
          else
            default_translations.first.content
          end
        end

        def api_wrapper
          @api_wrapper ||= InContextEditor::ApiWrapper.new
        end
      end
    end
  end
end
