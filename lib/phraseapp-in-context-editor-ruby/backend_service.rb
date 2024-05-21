require_relative "delegate/i18n_delegate"

module PhraseApp
  module InContextEditor
    class BackendService
      attr_accessor :blacklisted_keys

      def initialize(args = {})
        self
      end

      def translate(*args)
        if to_be_translated_without_phraseapp?(args)
          # *Ruby 2.7+ keyword arguments warning*
          #
          # This method uses keyword arguments.
          # There is a breaking change in ruby that produces warning with ruby 2.7 and won't work as expected with ruby 3.0
          # The "hash" parameter must be passed as keyword argument.
          #
          # Good:
          #  I18n.t(:salutation, :gender => 'w', :name => 'Smith')
          #  I18n.t(:salutation, **{ :gender => 'w', :name => 'Smith' })
          #  I18n.t(:salutation, **any_hash)
          #
          # Bad:
          #  I18n.t(:salutation, { :gender => 'w', :name => 'Smith' })
          #  I18n.t(:salutation, any_hash)
          #
          kw_args = args[1]
          if kw_args.present?
            I18n.translate_without_phraseapp(args[0], **kw_args)
          else
            I18n.translate_without_phraseapp(args[0])
          end
        else
          phraseapp_delegate_for(args)
        end
      end

      protected

      def to_be_translated_without_phraseapp?(args)
        PhraseApp::InContextEditor.disabled? || has_been_forced_to_resolve_with_phraseapp?(args)
      end

      def has_been_forced_to_resolve_with_phraseapp?(args)
        (args.last.is_a?(Hash) && args.last[:resolve] == false)
      end

      def given_key_from_args(args)
        extract_normalized_key_from_args(args)
      end

      def phraseapp_delegate_for(args)
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
