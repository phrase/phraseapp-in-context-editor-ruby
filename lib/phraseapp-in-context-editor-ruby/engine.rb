# -*- encoding : utf-8 -*-
require 'phraseapp-in-context-editor-ruby'
require 'i18n'

if defined? Rails
  module PhraseApp
    module InContextEditor
      class Engine < Rails::Engine
        initializer 'phraseapp-in-context-editor-ruby', before: :disable_dependency_loading do |app|
          if PhraseApp::InContextEditor.enabled?
            require 'phraseapp-in-context-editor-ruby/adapters/i18n'
            require 'phraseapp-in-context-editor-ruby/adapters/fast_gettext'
          end

          ActionView::Base.send :include, PhraseApp::InContextEditor::ViewHelpers
        end
      end
    end
  end
end
