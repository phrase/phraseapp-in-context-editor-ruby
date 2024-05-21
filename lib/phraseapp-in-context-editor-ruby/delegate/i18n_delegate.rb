require_relative "../delegate"

module PhraseApp
  module InContextEditor
    module Delegate
      class I18nDelegate < Base
        attr_accessor :key, :display_key

        def initialize(key, options = {}, original_args = nil)
          @key = key
          @options = options
          @original_args = original_args
          @display_key = @key
          super(decorated_key_name)
        end

        def method_missing(*args, &block)
          self.class.log "Trying to execute missing method ##{args.first} on key #{@key}"
          if @key.respond_to?(args.first)
            to_s.send(*args)
          else
            data = [@key]
            if data.respond_to?(args.first)
              data.send(*args, &block)
            else
              self.class.log "You tried to execute the missing method ##{args.first} on key #{@key} which is not supported. Please make sure you treat your translations as strings only."
              original_translation = ::I18n.translate_without_phraseapp(*@original_args, **@options)
              original_translation.send(*args, &block)
            end
          end
        end
      end
    end
  end
end
