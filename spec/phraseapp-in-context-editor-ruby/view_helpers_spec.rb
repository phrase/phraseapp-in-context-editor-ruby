require "spec_helper"
require "phraseapp-in-context-editor-ruby"
require "phraseapp-in-context-editor-ruby/view_helpers"

def content_security_policy_nonce
  "some_nonce"
end

describe PhraseApp::InContextEditor::ViewHelpers do
  before(:all) do
    class Helpers
      include PhraseApp::InContextEditor::ViewHelpers
    end
  end

  let(:helpers) { Helpers.new }

  describe "#load_in_context_editor" do
    let(:opts) { {enabled: true, prefix: "[[__", suffix: "__]]"} }

    subject { helpers.load_in_context_editor(opts) }

    context "editor is enabled" do
      before(:each) { PhraseApp::InContextEditor.config.enabled = true }

      describe "has right ICE bundle address" do
        it { is_expected.to include("<script nonce='some_nonce'>") }
        it { is_expected.to include("https://d2bgdldl6xit7z.cloudfront.net/latest/ice/index.js") }
        it { is_expected.to include("</script>") }
      end

      describe "prefix setting" do
        before(:each) { PhraseApp::InContextEditor.config.prefix = "[[__" }

        it { is_expected.to include("\"prefix\":\"[[__\"") }
      end

      describe "suffix setting" do
        before(:each) { PhraseApp::InContextEditor.config.suffix = "__]]" }

        it { is_expected.to include("\"suffix\":\"__]]\"") }
      end

      describe "origin setting" do
        it { is_expected.to include("\"origin\":\"in-context-editor-ruby\"") }
      end

      describe "overriding options" do
        let(:opts) { {prefix: "__%%"} }
        before(:each) { PhraseApp::InContextEditor.config.prefix = "__]]" }

        it { is_expected.not_to include("\"prefix\":\"__]]\"") }
        it { is_expected.to include("\"prefix\":\"__%%\"") }
      end
    end

    context "editor is disabled" do
      before(:each) do
        PhraseApp::InContextEditor.config.enabled = false
      end

      it { is_expected.to eql "" }
    end
  end
end
