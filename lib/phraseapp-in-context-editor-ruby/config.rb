# -*- encoding : utf-8 -*-
module PhraseApp
  module InContextEditor
    class Config
      CONFIG_OPTIONS = {
        project_id: nil,
        access_token: nil,
        enabled: false,
        skip_ssl_verification: false,
        backend: PhraseApp::InContextEditor::BackendService.new,
        prefix: "{{__",
        suffix: "__}}",
        api_host: "https://api.phrase.com",
        js_host: "phraseapp.com",
        js_use_ssl: true,
        js_path: "/assets/in-context-editor/2.0/app.js",
        js_options: {},
        cache_key_segments_initial: ["simple_form"],
        cache_lifetime: 300,
        ignored_keys: [],
      }.freeze

      CONFIG_OPTIONS_GLOBAL_ONLY = [
        :access_token,
        :skip_ssl_verification,
        :api_host
      ].freeze

      CONFIG_OPTIONS.each do |option, default_value|
        class_eval "@@#{option} = CONFIG_OPTIONS[:#{option}]"

        define_method("#{option}=") do |value|
          instance_eval "@#{option} = value; self.class.invalidate_api_client"
        end unless CONFIG_OPTIONS_GLOBAL_ONLY.include?(option)

        define_method("#{option}") do
          instance_eval "defined?(@#{option}) ? @#{option} : self.class.#{option}"
        end

        define_singleton_method("#{option}=") do |value|
          instance_eval "@@#{option} = value; invalidate_api_client"
        end

        define_singleton_method("#{option}") do
          instance_eval "@@#{option}"
        end
      end

      def self.api_client
        @@api_client ||= build_api_client
      end

      def api_client
        self.class.api_client
      end

      def assign_values(config_options={})
        config_options.each do |config_option, value|
          self.send("#{config_option}=", value)
        end
      end

      def self.reset_to_defaults!
        CONFIG_OPTIONS.each do |option, default_value|
          send("#{option}=", default_value)
        end
      end

    protected
      def self.invalidate_api_client
        @@api_client = nil
      end

      def self.build_api_client
        credentials = PhraseApp::Auth::Credentials.new(
          token: @@access_token,
          host: @@api_host,
          skip_ssl_verification: @@skip_ssl_verification
        )
        PhraseApp::Client.new(credentials)
      end
    end
  end
end
