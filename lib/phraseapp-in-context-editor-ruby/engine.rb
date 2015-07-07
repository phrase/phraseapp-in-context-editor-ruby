# -*- encoding : utf-8 -*-

require 'phraseapp-in-context-editor-ruby'
require 'i18n'

if defined? Rails
  class InContextEditor::Engine < Rails::Engine

    initializer 'phraseapp-in-context-editor-ruby', :after => :disable_dependency_loading do |app|
      if InContextEditor.enabled?
        require 'phraseapp-in-context-editor-ruby/adapters/i18n'
        require 'phraseapp-in-context-editor-ruby/adapters/fast_gettext'
      end

      ActionView::Base.send :include, InContextEditor::ViewHelpers
    end
  end
end
