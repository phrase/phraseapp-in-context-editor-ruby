# -*- encoding : utf-8 -*-
module PhraseApp
  module InContextEditor
    module HashFlattener
      FLATTEN_SEPARATOR = "."
      SEPARATOR_ESCAPE_CHAR = "\001"

      def self.flatten(hash, escape, previous_key=nil, &block)
        hash.each_pair do |key, value|
          key = escape_default_separator(key) if escape
          current_key = [previous_key, key].compact.join(FLATTEN_SEPARATOR).to_sym
          yield current_key, value
          flatten(value, escape, current_key, &block) if value.is_a?(Hash)
        end
      end

      def self.expand_flat_hash(flat_hash, prefix=nil)
        flat_hash ||= []
        result = flat_hash.map do |key, value|
          key = key.gsub(/#{prefix}[\.]?/, '') if prefix
          to_nested_hash(key, value)
        end

        result = result.inject({}) { |hash, subhash| hash.deep_merge!(subhash) }
        result
      end

      def self.to_nested_hash key, value
        if contains_only_dots?(key) or starts_with_dot?(key) or ends_with_dot?(key)
          {key.to_sym => value}
        else
          key.to_s.split(".").reverse.inject(value) { |hash, part| {part.to_sym => hash} }
        end
      end

      def self.contains_only_dots?(string)
        string.to_s.gsub(/\./, "").length == 0
      end

      def self.starts_with_dot?(string)
        string.to_s.start_with?(".")
      end

      def self.ends_with_dot?(string)
        string.to_s.end_with?(".")
      end

      def self.escape_default_separator(key)
        key.to_s.tr(FLATTEN_SEPARATOR, SEPARATOR_ESCAPE_CHAR)
      end
    end
  end
end
