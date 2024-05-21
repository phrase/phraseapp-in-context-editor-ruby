if defined?(I18n)
  module I18n
    class << self
      def translate_with_phraseapp(...)
        PhraseApp::InContextEditor.backend.translate(...)
      end
      alias_method :translate_without_phraseapp, :translate
      alias_method :translate, :translate_with_phraseapp
      alias_method :t, :translate
    end
  end
end
