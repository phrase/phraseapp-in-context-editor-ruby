# -*- encoding : utf-8 -*-
require 'rainbow'
require 'phraseapp-ruby'

module InContextEditor
  autoload :Config, 'phraseapp-ruby-in-context-editor/config'

  class << self

    def config
      Thread.current[:phrase_config] ||= InContextEditor::Config.new
    end

    def config=(value)
      Thread.current[:phrase_config] = value
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

    def access_token
      config.access_token
    end

    def cache_key_segments_initial
      config.cache_key_segments_initial
    end

    def cache_lifetime
      config.cache_lifetime
    end

    def ignored_keys
      config.ignored_keys
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

    def js_use_ssl
      config.js_use_ssl
    end

    def js_host
      config.js_host
    end

    def api_client
      config.api_client
    end
  end

  def self.configure
    yield(self.config)
  end

  autoload :ViewHelpers, 'phraseapp-ruby-in-context-editor/view_helpers'

  require 'phraseapp-ruby-in-context-editor/version'
  require 'phraseapp-ruby-in-context-editor/engine'
  require 'phraseapp-ruby-in-context-editor/delegate'
  require 'phraseapp-ruby-in-context-editor/backend_service'
  require 'phraseapp-ruby-in-context-editor/view_helpers'
end

# Only load adapters directly if non-rails app, otherwise use engine
unless defined? Rails
  require 'phraseapp-ruby-in-context-editor/adapters/i18n'
  require 'phraseapp-ruby-in-context-editor/adapters/fast_gettext'
end
