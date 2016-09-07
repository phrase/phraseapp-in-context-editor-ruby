# -*- encoding : utf-8 -*-

module PhraseApp
  module InContextEditor
    class Config
      attr_accessor :project_id,
        :access_token,
        :enabled,
        :skip_ssl_verification,
        :backend,
        :api_client,
        :prefix,
        :suffix,
        :api_host,
        :js_host,
        :js_use_ssl,
        :js_path,
        :js_options,
        :cache_key_segments_initial,
        :cache_lifetime,
        :ignored_keys

      def initialize(attrs={})
        @project_id = attrs.fetch(:project_id, nil)
        @access_token = attrs.fetch(:access_token, nil)
        @enabled = attrs.fetch(:enabled, false)
        @skip_ssl_verification = attrs.fetch(:skip_ssl_verification, false)
        @backend = attrs.fetch(:backend, PhraseApp::InContextEditor::BackendService.new)
        @prefix = attrs.fetch(:prefix, "{{__")
        @suffix = attrs.fetch(:suffix, "__}}")
        @api_host = attrs.fetch(:api_host, "https://api.phraseapp.com")
        @js_host = attrs.fetch(:js_host, "phraseapp.com")
        @js_use_ssl = attrs.fetch(:js_use_ssl, true)
        @js_path = attrs.fetch(:js_path, "/assets/in-context-editor/2.0/app.js")
        @js_options = attrs.fetch(:js_options, {})
        @cache_key_segments_initial = attrs.fetch(:cache_key_segments_initial, ["simple_form"])
        @cache_lifetime = attrs.fetch(:cache_lifetime, 300)
        @ignored_keys = attrs.fetch(:ignored_keys, [])
        @api_client = attrs.fetch(:api_client, build_api_client)
      end

      def access_token=(access_token)
        @access_token = access_token
        reload_api_client
      end

      def api_host=(api_host)
        @api_host = api_host
        reload_api_client
      end

      def skip_ssl_verification=(skip_ssl_verification)
        @skip_ssl_verification = skip_ssl_verification
        reload_api_client
      end

    protected
      def build_api_client
        auth_credentials = PhraseApp::Auth::Credentials.new(
          token: @access_token,
          host: @api_host,
          skip_ssl_verification: @skip_ssl_verification
        )

        PhraseApp::Client.new(auth_credentials)
      end

      def reload_api_client
        @api_client = build_api_client
      end
    end
  end
end
