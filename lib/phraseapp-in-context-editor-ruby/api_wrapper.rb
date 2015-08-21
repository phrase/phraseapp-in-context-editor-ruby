require 'phraseapp-in-context-editor-ruby/api_collection'

module PhraseApp
  module InContextEditor
    class ApiWrapper
      def initialize
        @api_client = PhraseApp::InContextEditor.api_client
      end

      def default_locale
        @default_locale ||= select_default_locale
      end

      def default_translation(key)
        params = PhraseApp::RequestParams::TranslationsByKeyParams.new
        translations = PhraseApp::InContextEditor::ApiCollection.new(@api_client, "translations_by_key", project_and_key_id(key), params).collection
        return unless translations.present?

        translations.select{ |translation| translation.locale["id"] == default_locale.id }
      end

      def keys_with_prefix(prefix)
        params = PhraseApp::RequestParams::KeysListParams.new(q:"#{prefix}*")
        keys_list(params)
      end

      def keys_by_names(names)
        names = names.join(',')
        params = PhraseApp::RequestParams::KeysListParams.new(:q => "name:#{names}")
        keys_list(params)
      end

      def keys_list(params)
        PhraseApp::InContextEditor::ApiCollection.new(@api_client, "keys_list", project_id, params).collection
      end

      def blacklisted_keys
        PhraseApp::InContextEditor::ApiCollection.new(@api_client, "blacklisted_keys_list", project_id).collection.map{ |rule| rule.name }
      end

      private

      def select_default_locale
        locales = PhraseApp::InContextEditor::ApiCollection.new(@api_client, "locales_list", project_id).collection
        return unless locales.present?

        locales.select{ |loc| loc.default }.first
      end

      def project_id
        [PhraseApp::InContextEditor.project_id]
      end

      def project_and_key_id(key)
        project_id << key.id
      end
    end
  end
end
