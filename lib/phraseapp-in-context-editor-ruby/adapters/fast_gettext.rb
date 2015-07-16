# -*- encoding : utf-8 -*-

require 'phraseapp-in-context-editor-ruby/delegate/fast_gettext'

module FastGettext
  module Translation
    def __with_phraseapp(*args)
      PhraseApp::InContextEditor::Delegate::FastGettext.new(:_, *args)
    end
    alias_method :__without_phraseapp, :_
    alias_method :_, :__with_phraseapp

    def n__with_phraseapp(*args)
      PhraseApp::InContextEditor::Delegate::FastGettext.new(:n_, *args)
    end
    alias_method :n__without_phraseapp, :n_
    alias_method :n_, :n__with_phraseapp

    def s__with_phraseapp(*args)
      PhraseApp::InContextEditor::Delegate::FastGettext.new(:s_, *args)
    end
    alias_method :s__without_phraseapp, :s_
    alias_method :s_, :s__with_phraseapp
  end
end if defined? FastGettext::Translation
