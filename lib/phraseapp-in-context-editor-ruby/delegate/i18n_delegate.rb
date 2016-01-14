# -*- encoding : utf-8 -*-

require 'phraseapp-in-context-editor-ruby/cache'
require 'phraseapp-in-context-editor-ruby/hash_flattener'
require 'phraseapp-in-context-editor-ruby/delegate'
require 'phraseapp-in-context-editor-ruby/api_wrapper'
require 'phraseapp-in-context-editor-ruby/displayable_key_identifier'

require 'set'

module PhraseApp
  module InContextEditor
    module Delegate
      class I18nDelegate < Base
        attr_accessor :key, :display_key, :options, :api_client, :fallback_keys, :original_args

        def initialize(key, options={}, original_args=nil)
          @key = key
          @options = options
          @original_args = original_args
          @display_key = DisplayableKeyIdentifier.new(api_wrapper).identify(@key, @options)
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

        def translation_or_subkeys
          return nil if @key.nil? || @key.to_s == ""

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
