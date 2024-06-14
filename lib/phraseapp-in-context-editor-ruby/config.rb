module PhraseApp
  module InContextEditor
    class Config
      CONFIG_OPTIONS = {
        account_id: nil,
        project_id: nil,
        datacenter: "eu",
        enabled: false,
        backend: PhraseApp::InContextEditor::BackendService.new,
        prefix: "{{__",
        suffix: "__}}",
        origin: "in-context-editor-ruby",
        ignored_keys: []
      }.freeze

      CONFIG_OPTIONS.each do |option, default_value|
        class_eval "@@#{option} = CONFIG_OPTIONS[:#{option}]", __FILE__, __LINE__

        define_method("#{option}=") do |value|
          instance_eval "@#{option} = value", __FILE__, __LINE__
        end

        define_method(option.to_s) do
          instance_eval "defined?(@#{option}) ? @#{option} : self.class.#{option}", __FILE__, __LINE__
        end

        define_singleton_method("#{option}=") do |value|
          instance_eval "@@#{option} = value", __FILE__, __LINE__
        end

        define_singleton_method(option.to_s) do
          instance_eval "@@#{option}", __FILE__, __LINE__
        end
      end

      def assign_values(config_options = {})
        config_options.each do |config_option, value|
          send("#{config_option}=", value)
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
