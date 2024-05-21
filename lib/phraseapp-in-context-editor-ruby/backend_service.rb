require_relative "delegate/i18n_delegate"

module PhraseApp
  module InContextEditor
    class BackendService
      def initialize(args = {})
        self
      end

      def translate(...)
        if to_be_translated_without_phraseapp?(...)
          I18n.translate_without_phraseapp(...)
        else
          phraseapp_delegate_for(...)
        end
      end

      protected

      def to_be_translated_without_phraseapp?(...)
        PhraseApp::InContextEditor.disabled? || ignored_key?(...) || has_been_forced_to_resolve_with_phraseapp?(...)
      end

      def ignored_key?(*args)
        key = given_key_from_args(args)
        PhraseApp::InContextEditor.ignored_keys.any? do |ignored_key|
          key.to_s[/\A#{ignored_key.gsub("*", ".*")}\Z/]
        end
      end

      def has_been_forced_to_resolve_with_phraseapp?(*args)
        (args.last.is_a?(Hash) && args.last[:resolve] == false)
      end

      def given_key_from_args(args)
        extract_normalized_key_from_args(args)
      end

      def phraseapp_delegate_for(*args)
        key = given_key_from_args(args)
        return nil unless present?(key)

        options = options_from_args(args)
        PhraseApp::InContextEditor::Delegate::I18nDelegate.new(key, options, args)
      end

      def extract_normalized_key_from_args(args)
        transformed_args = transform_args(args)
        normalized_key(transformed_args)
      end

      def transform_args(args)
        duped_args = args.map { |item| (item.is_a?(Symbol) || item.nil?) ? item : item.dup }
      end

      def normalized_key(duped_args)
        splitted_args = split_args(duped_args)
        key = I18n::Backend::Flatten.normalize_flat_keys(*splitted_args)
        key.gsub!("..", ".")
        key.gsub!(/^\./, "")
        key
      end

      def split_args(args)
        options = options_from_args(args)
        key ||= args.shift
        locale = options.delete(:locale) || I18n.locale
        [locale, key, options[:scope], nil]
      end

      def options_from_args(args)
        args.last.is_a?(Hash) ? args.pop : {}
      end

      def blank?(str)
        raise "blank?(str) can only be given a String or nil" unless str.is_a?(String) || str.nil?
        str.nil? || str == ""
      end

      def present?(str)
        raise "present?(str) can only be given a String or nil" unless str.is_a?(String) || str.nil?
        !blank?(str)
      end
    end
  end
end
