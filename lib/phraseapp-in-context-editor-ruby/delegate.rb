module PhraseApp
  module InContextEditor
    module Delegate
      class Base < String
        def to_s
          decorated_key_name.to_s
        end
        alias_method :camelize, :to_s
        alias_method :underscore, :to_s
        alias_method :classify, :to_s
        alias_method :dasherize, :to_s
        alias_method :tableize, :to_s

        # Delegate .html_safe from accessing Delegate object as if it was a hash,
        # but instead perform it on the resulting string
        delegate :html_safe, to: :to_s

        def self.log(message)
          message = "phrase: #{message}"
          if defined?(Rails) && Rails.respond_to?(:logger)
            Rails.logger.warn(message)
          else
            warn message
          end
        end

        protected

        def decorated_key_name
          "#{PhraseApp::InContextEditor.prefix}phrase_#{normalized_display_key}#{PhraseApp::InContextEditor.suffix}"
        end

        def normalized_display_key
          if @display_key.nil?
            @display_key
          else
            @display_key.gsub("<", "[[[[[[html_open]]]]]]").gsub(">", "[[[[[[html_close]]]]]]")
          end
        end
      end
    end
  end
end
