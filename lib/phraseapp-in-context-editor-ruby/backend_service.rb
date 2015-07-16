# -*- encoding : utf-8 -*-
require 'phraseapp-in-context-editor-ruby/api_collection'
require 'phraseapp-in-context-editor-ruby/delegate/i18n'

module PhraseApp
  module InContextEditor
    class BackendService

      attr_accessor :blacklisted_keys

      def initialize(args = {})
        self
      end

      def translate(*args)
        if to_be_translated_without_phraseapp?(args)
          I18n.translate_without_phraseapp(*args)
        else
          phraseapp_delegate_for(args)
        end
      end

    protected
      def to_be_translated_without_phraseapp?(args)
        PhraseApp::InContextEditor.disabled? or has_been_given_blacklisted_key?(args) or has_been_given_ignored_key?(args) or has_been_forced_to_resolve_with_phraseapp?(args)
      end

      def has_been_given_blacklisted_key?(args)
        key = given_key_from_args(args)
        has_blacklist_entry_for_key?(key)
      end

      def has_been_given_ignored_key?(args)
        key = given_key_from_args(args)
        key_is_ignored?(key)
      end

      def has_been_forced_to_resolve_with_phraseapp?(args)
        (args.last.is_a?(Hash) and args.last[:resolve] == false)
      end

      def given_key_from_args(args)
        extract_normalized_key_from_args(args)
      end

      def has_blacklist_entry_for_key?(key)
        blacklisted_keys.each do |blacklisted_key|
          return true if present?(key.to_s[/\A#{blacklisted_key.gsub("*", ".*")}\Z/])
        end
        false
      end

      def key_is_ignored?(key)
        PhraseApp::InContextEditor.ignored_keys.each do |ignored_key|
          return true if present?(key.to_s[/\A#{ignored_key.gsub("*", ".*")}\Z/])
        end
        false
      end

      def blacklisted_keys
        @blacklisted_keys ||= api_wrapper.blacklisted_keys
      end

      def phraseapp_delegate_for(args)
        key = given_key_from_args(args)
        return nil unless present?(key)
        options = args[1].nil? ? {} : args[1]
        PhraseApp::InContextEditor::Delegate::I18n.new(key, options, args)
      end

      def extract_normalized_key_from_args(args)
        transformed_args = transform_args(args)
        normalized_key(transformed_args)
      end

      def transform_args(args)
        duped_args = args.map { |item| (item.is_a?(Symbol) or item.nil?) ? item : item.dup }
        transform_args_based_on_caller(duped_args)
      end

      def normalized_key(duped_args)
        splitted_args = split_args(duped_args)
        key = I18n::Backend::Flatten.normalize_flat_keys(*splitted_args)
        key.gsub!("..", ".")
        key.gsub!(/^\./, '')
        key
      end

      def split_args(args)
        options = options_from_args(args)
        key ||= args.shift
        locale = options.delete(:locale) || I18n.locale
        return [locale, key, options[:scope], nil]
      end

      def options_from_args(args)
        args.last.is_a?(Hash) ? args.pop : {}
      end

      def transform_args_based_on_caller(args)
        translation_caller = identify_caller

        if translation_caller and args.first =~ /^\./
          options = options_from_args(args)

          if not present?(options[:scope]) and present?(translation_caller)
            options[:scope] = translation_caller
          end

          args.push(options)
          parts = args.first.to_s.split(".").select { |e| not blank?(e) }
          args[0] = parts[0] if parts.size == 1
        end

        args
      end

      def identify_caller
        translation_caller = nil
        send(:caller)[0..6].each do |intermediate_caller|
          translation_caller = calling_template(intermediate_caller) unless translation_caller
        end

        if present?(translation_caller)
          find_lookup_scope(translation_caller)
        else
          nil
        end
      end

      def calling_template(string)
        string.match(/(views)(\/.+)(?>:[0-9]+:in)/)
      end

      def blank?(str)
        raise "blank?(str) can only be given a String or nil" unless str.is_a?(String) or str.nil?
        str.nil? or str == ''
      end

      def present?(str)
        raise "present?(str) can only be given a String or nil" unless str.is_a?(String) or str.nil?
        not blank?(str)
      end

      def find_lookup_scope(caller)
        split_path = caller[2][1..-1].split(".")[0].split("/")

        template_or_partial = remove_underscore_form_partial(split_path[-1])
        split_path[-1] = template_or_partial

        split_path.map!(&:to_sym)
      end

      def remove_underscore_form_partial(template_or_partial)
        if template_or_partial.to_s[0,1] == "_"
          template_or_partial.to_s[1..-1]
        else
          template_or_partial.to_s
        end
      end

      def api_wrapper
        @api_wrapper ||= PhraseApp::InContextEditor::ApiWrapper.new
      end
    end
  end
end
