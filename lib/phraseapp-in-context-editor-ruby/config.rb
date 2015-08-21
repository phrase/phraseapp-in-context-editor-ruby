# -*- encoding : utf-8 -*-

module PhraseApp
  module InContextEditor
    class Config
      def project_id
        @@project_id = "" if !defined? @@project_id or @@project_id.nil?
        @@project_id
      end

      def project_id=(project_id)
        @@project_id = project_id
      end

      def access_token
        @@access_token = "" if !defined? @@access_token or @@access_token.nil?
        @@access_token
      end

      def access_token=(access_token)
        @@access_token = access_token
      end

      def enabled
        @@enabled = false if !defined? @@enabled or @@enabled.nil?
        @@enabled
      end

      def enabled=(enabled)
        @@enabled = enabled
      end

      def skip_ssl_verification
        @@skip_ssl_verification = false if !defined? @@skip_ssl_verification or @@skip_ssl_verification.nil?
        @@skip_ssl_verification
      end

      def skip_ssl_verification=(skip_ssl_verification)
        @@skip_ssl_verification = skip_ssl_verification
      end

      def backend
        @@backend ||= PhraseApp::InContextEditor::BackendService.new
      end

      def backend=(backend)
        @@backend = backend
      end

      def api_client
        @@api_client ||= authorized_api_client
      end

      def prefix
        @@prefix ||= "{{__"
      end

      def prefix=(prefix)
        @@prefix = prefix
      end

      def suffix
        @@suffix ||= "__}}"
      end

      def suffix=(suffix)
        @@suffix = suffix
      end

      def api_host
        @@api_host = "https://api.phraseapp.com" if !defined? @@api_host or @@api_host.nil?
        @@api_host
      end

      def api_host=(api_host)
        @@api_host = api_host
      end

      def js_host
        @@js_host ||= 'phraseapp.com'
      end

      def js_host=(js_host)
        @@js_host = js_host
      end

      def js_use_ssl
        @@js_use_ssl = true if !defined? @@js_use_ssl or @@js_use_ssl.nil?
        @@js_use_ssl
      end

      def js_use_ssl=(js_use_ssl)
        @@js_use_ssl = js_use_ssl
      end

      def cache_key_segments_initial
        @@cache_key_segments_initial ||= ["simple_form"]
      end

      def cache_key_segments_initial=(cache_key_segments_initial=[])
        @@cache_key_segments_initial = cache_key_segments_initial
      end

      def cache_lifetime
        @@cache_lifetime ||= 300
      end

      def cache_lifetime=(cache_lifetime)
        @@cache_lifetime = cache_lifetime
      end

      def ignored_keys
        @@ignored_keys ||= []
      end

      def ignored_keys=(ignored_keys)
        @@ignored_keys = ignored_keys
      end

    protected
      def authorized_api_client
        credentials = PhraseApp::Auth::Credentials.new(token: PhraseApp::InContextEditor.access_token, host: PhraseApp::InContextEditor.api_host, skip_ssl_verification: PhraseApp::InContextEditor.skip_ssl_verification)
        client = PhraseApp::Client.new(credentials)
      end
    end
  end
end
