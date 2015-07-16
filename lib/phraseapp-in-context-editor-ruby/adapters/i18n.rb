# -*- encoding : utf-8 -*-

module I18n
  class << self
    def translate_with_phraseapp(*args)
      PhraseApp::InContextEditor.backend.translate(*args)
    end
    alias_method :translate_without_phraseapp, :translate
    alias_method :translate, :translate_with_phraseapp
    alias_method :t, :translate
  end
end if defined?(I18n)
