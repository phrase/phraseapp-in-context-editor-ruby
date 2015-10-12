module PhraseApp
  module InContextEditor
    class FallbackKeysFetcher

      def self.extract_fallback_keys(key, options)
        fallback_items = []
        if options.has_key?(:default)
          if options[:default].kind_of?(Array)
            fallback_items = options[:default]
          else
            fallback_items << options[:default]
          end
        end

        return fallback_items.map{ |item| process_fallback_item(item, key, options) }.flatten.uniq
      end

      def self.process_fallback_item(item, key, options)
        fallback_keys = []
        if item.kind_of?(Symbol)
          fallback_key_name = item.to_s
          if options.has_key?(:scope)
            if options[:scope].is_a?(Array)
              fallback_key_name = "#{options[:scope].join(".")}.#{item}"
            else
              fallback_key_name = "#{options[:scope]}.#{item}"
            end
          end
          fallback_keys << fallback_key_name

          if key == "helpers.label.#{fallback_key_name}" # http://apidock.com/rails/v3.1.0/ActionView/Helpers/FormHelper/label
            fallback_keys << "activerecord.attributes.#{fallback_key_name}"
          end

          if key.start_with?("simple_form.") # special treatment for simple form
            fallback_keys << "activerecord.attributes.#{item}"
          end
        end

        return fallback_keys
      end
    end
  end
end