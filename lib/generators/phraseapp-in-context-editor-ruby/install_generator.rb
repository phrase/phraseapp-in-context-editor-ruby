# -*- encoding : utf-8 -*-

module InContextEditor
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a PhraseApp In-Context-Editor initializer for your application."
      class_option :access_token, type: :string, desc: "Your Phraseapp OAuth access token", required: true
      class_option :project_id, type: :string, desc: "Your Phraseapp project id", required: true

      def copy_initializer
        template "in_context_editor.rb", "config/initializers/in_context_editor.rb"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end
