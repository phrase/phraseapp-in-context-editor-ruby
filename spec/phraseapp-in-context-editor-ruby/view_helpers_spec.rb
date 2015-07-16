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
    context "phrase is enabled" do
      before(:each) do
        PhraseApp::InContextEditor.stub(:enabled?).and_return(true)
      end

      it "should return a javascript block" do
        helpers.phraseapp_in_context_editor_js.should include("<script>")
        helpers.phraseapp_in_context_editor_js.should include("</script>")
      end

      it "should use the set host name" do
        PhraseApp::InContextEditor.config.js_host = "faridbang.de"
        helpers.phraseapp_in_context_editor_js.should include("faridbang.de")
      end

      it "should use https when configured" do
        PhraseApp::InContextEditor.config.js_use_ssl = true
        helpers.phraseapp_in_context_editor_js.should include("https")
      end

      it "should use http when configured" do
        PhraseApp::InContextEditor.config.js_use_ssl = false
        helpers.phraseapp_in_context_editor_js.should include("http")
        helpers.phraseapp_in_context_editor_js.should_not include("https")
      end
    end

    context "phrase is disabled" do
      before(:each) do
        PhraseApp::InContextEditor.stub(:enabled?).and_return(false)
      end

      it "should not return a thing" do
        helpers.phraseapp_in_context_editor_js.should == ""
      end
    end
  end
end
