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
        api_host: "https://api.phraseapp.com",
        js_host: "phraseapp.com",
        js_use_ssl: true,
        js_path: "/assets/in-context-editor/2.0/app.js",
        js_options: {},
        cache_key_segments_initial: ["simple_form"],
        cache_lifetime: 300,
        ignored_keys: [],
      }.freeze

      CONFIG_OPTIONS.each do |option, default_value|
        class_eval "@@#{option} = CONFIG_OPTIONS[:#{option}]"

        define_method("#{option}=") do |value|
          instance_eval "@#{option} = value"
        end

        define_method("#{option}") do
          instance_eval "defined?(@#{option}) ? @#{option} : self.class.#{option}"
        end

        define_singleton_method("#{option}=") do |value|
          instance_eval "@@#{option} = value"
        end

        define_singleton_method("#{option}") do
          instance_eval "@@#{option}"
        end
      end

      def self.reset_to_defaults!
        CONFIG_OPTIONS.each do |option, default_value|
          send("#{option}=", default_value)
        end
      end
    end
  end
end
