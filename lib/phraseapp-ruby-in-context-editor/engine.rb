# -*- encoding : utf-8 -*-

require 'phraseapp-ruby-in-context-editor'
require 'i18n'

if defined? Rails
  class InContextEditor::Engine < Rails::Engine

    initializer 'phraseapp-ruby-in-context-editor', :after => :disable_dependency_loading do |app|
      if InContextEditor.enabled?
        require 'phraseapp-ruby-in-context-editor/adapters/i18n'
        require 'phraseapp-ruby-in-context-editor/adapters/fast_gettext'
      end

      ActionView::Base.send :include, InContextEditor::ViewHelpers
    end
  end
end
