# -*- encoding : utf-8 -*-

require 'phraseapp-ruby-in-context-editor/delegate/fast_gettext'

module FastGettext
  module Translation
    def __with_phrase(*args)
      InContextEditor::Delegate::FastGettext.new(:_, *args)
    end
    alias_method :__without_phrase, :_
    alias_method :_, :__with_phrase

    def n__with_phrase(*args)
      InContextEditor::Delegate::FastGettext.new(:n_, *args)
    end
    alias_method :n__without_phrase, :n_
    alias_method :n_, :n__with_phrase

    def s__with_phrase(*args)
      InContextEditor::Delegate::FastGettext.new(:s_, *args)
    end
    alias_method :s__without_phrase, :s_
    alias_method :s_, :s__with_phrase
  end
end if defined? FastGettext::Translation
