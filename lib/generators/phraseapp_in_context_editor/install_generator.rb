# -*- encoding : utf-8 -*-

module PhraseappInContextEditor
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Creates a PhraseApp In-Context-Editor initializer for your application."
      class_option :access_token, type: :string, desc: "Your PhraseApp access token", required: true
      class_option :project_id, type: :string, desc: "Your PhraseApp project id", required: true

      def copy_initializer
        template "phraseapp_in_context_editor.rb", "config/initializers/phraseapp_in_context_editor.rb"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end
