require "request_store"

module PhraseApp
  module InContextEditor
    autoload :Config, "phraseapp-in-context-editor-ruby/config"

    class << self
      def config
        RequestStore.store[:phraseapp_config] ||= PhraseApp::InContextEditor::Config.new
      end

      def config=(value)
        RequestStore.store[:phraseapp_config] = value
      end

      def backend
        config.backend
      end

      def suffix
        config.suffix
      end

      def prefix
        config.prefix
      end

      def project_id
        config.project_id
      end

      def account_id
        config.account_id
      end

      def datacenter
        config.datacenter
      end

      def enabled=(value)
        config.enabled = value
      end

      def enabled?
        config.enabled
      end

      def disabled?
        !config.enabled
      end
    end

    def self.configure
      yield(PhraseApp::InContextEditor::Config)
    end

    def self.with_config(config_options = {}, &block)
      original_config = config.dup
      config.assign_values(config_options)
      yield
    ensure
      self.config = original_config
    end
  end

  autoload :ViewHelpers, "phraseapp-in-context-editor-ruby/view_helpers"

  require "phraseapp-in-context-editor-ruby/engine"
  require "phraseapp-in-context-editor-ruby/delegate"
  require "phraseapp-in-context-editor-ruby/backend_service"
  require "phraseapp-in-context-editor-ruby/view_helpers"
end

# Only load adapters directly if non-rails app, otherwise use engine
unless defined? Rails
  require "phraseapp-in-context-editor-ruby/adapters/i18n"
  require "phraseapp-in-context-editor-ruby/adapters/fast_gettext"
end
