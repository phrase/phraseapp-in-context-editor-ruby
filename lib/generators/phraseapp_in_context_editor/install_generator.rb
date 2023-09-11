module PhraseappInContextEditor
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Creates a Phrase In-Context-Editor initializer for your application."
      class_option :account_id, type: :string, desc: "Your Phrase account id", required: true
      class_option :project_id, type: :string, desc: "Your Phrase project id", required: true

      def copy_initializer
        template "phraseapp_in_context_editor.rb", "config/initializers/phraseapp_in_context_editor.rb"
      end
    end
  end
end
