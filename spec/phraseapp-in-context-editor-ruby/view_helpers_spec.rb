require 'spec_helper'
require 'phraseapp-in-context-editor-ruby'
require 'phraseapp-in-context-editor-ruby/view_helpers'

describe PhraseApp::InContextEditor::ViewHelpers do
  before(:all) do
    class Helpers
      include PhraseApp::InContextEditor::ViewHelpers
    end
  end

  let(:helpers) { Helpers.new }

  describe "#phraseapp_in_context_editor_js" do
    let(:opts) { nil }

    subject { helpers.phraseapp_in_context_editor_js(opts) }

    before(:each) do
      PhraseApp::InContextEditor::Config.js_host = "custom.phraseapp.com"
    end

    context "editor is enabled" do
      before(:each) do
        PhraseApp::InContextEditor::Config.enabled = true
      end

      it { is_expected.to include("<script>") }
      it { is_expected.to include("</script>") }

      describe "js host setting" do
        it { is_expected.to include("custom.phraseapp.com") }
      end

      describe "tls setting" do
        context "tls enabled" do
          before(:each) do
            PhraseApp::InContextEditor::Config.js_use_ssl = true
          end

          it { is_expected.to include("https://") }
        end

        context "tls disabled" do
          before(:each) do
            PhraseApp::InContextEditor::Config.js_use_ssl = false
          end

          it { is_expected.to include("http://") }
        end
      end

      describe "asset path setting" do
        context "no custom asset path set" do
          it { is_expected.to include("/assets/in-context-editor/2.0/app.js") }
        end

        context "custom asset path set" do
          before(:each) do
            PhraseApp::InContextEditor::Config.js_path = "/my-assets/app.js"
          end

          it { is_expected.to include("/my-assets/app.js") }
        end
      end

      describe "api host setting" do
        before(:each) do
          PhraseApp::InContextEditor::Config.api_host = "http://localhost:3000"
        end

        it { is_expected.to include("\"apiBaseUrl\":\"http://localhost:3000/api/v2\"") }
      end

      describe "prefix setting" do
        before(:each) do
          PhraseApp::InContextEditor::Config.prefix = "[[____"
        end

        it { is_expected.to include("\"prefix\":\"[[____\"") }
      end

      describe "suffix setting" do
        before(:each) do
          PhraseApp::InContextEditor::Config.suffix = "____]]"
        end

        it { is_expected.to include("\"suffix\":\"____]]\"") }
      end

      describe "overriding options" do
        let(:opts) { {prefix: "__%%"} }

        before(:each) do
          PhraseApp::InContextEditor.config.prefix = "____]]"
        end

        it { is_expected.not_to include("\"prefix\":\"____]]\"") }
        it { is_expected.to include("\"prefix\":\"__%%\"") }
      end
    end

    context "editor is disabled" do
      before(:each) do
        PhraseApp::InContextEditor::Config.enabled = false
      end

      it { is_expected.to eql "" }
    end
  end
end
