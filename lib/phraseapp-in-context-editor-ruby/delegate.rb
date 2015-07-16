# -*- encoding : utf-8 -*-

module PhraseApp
  module InContextEditor
    module Delegate
      class Base < String
        def to_s
          "#{decorated_key_name}"
        end
        alias :camelize :to_s
        alias :underscore :to_s
        alias :classify :to_s
        alias :dasherize :to_s
        alias :tableize :to_s

        def self.log(message)
          message = "phrase: #{message}"
          if defined?(Rails) and Rails.respond_to?(:logger)
            Rails.logger.warn(message)
          else
            $stderr.puts message
          end
        end

      protected
        def decorated_key_name
          "#{PhraseApp::InContextEditor.prefix}phrase_#{normalized_display_key}#{PhraseApp::InContextEditor.suffix}"
        end

        def normalized_display_key
          unless @display_key.nil?
            @display_key.gsub("<", "[[[[[[html_open]]]]]]").gsub(">", "[[[[[[html_close]]]]]]")
          else
            @display_key
          end
        end
      end
    end
  end
end
