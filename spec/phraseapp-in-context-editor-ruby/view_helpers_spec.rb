require 'spec_helper'
require 'phraseapp-in-context-editor-ruby'
require 'phraseapp-in-context-editor-ruby/view_helpers'

describe InContextEditor::ViewHelpers do
  before(:all) do
    class Helpers
      include InContextEditor::ViewHelpers
    end
  end

  let(:helpers) { Helpers.new }

  describe "#phraseapp_javascript" do
    context "phrase is enabled" do
      before(:each) do
        InContextEditor.stub(:enabled?).and_return(true)
      end

      it "should return a javascript block" do
        helpers.phraseapp_javascript.should include("<script>")
        helpers.phraseapp_javascript.should include("</script>")
      end

      it "should use the set host name" do
        InContextEditor.config.js_host = "faridbang.de"
        helpers.phraseapp_javascript.should include("faridbang.de")
      end

      it "should use https when configured" do
        InContextEditor.config.js_use_ssl = true
        helpers.phraseapp_javascript.should include("https")
      end

      it "should use http when configured" do
        InContextEditor.config.js_use_ssl = false
        helpers.phraseapp_javascript.should include("http")
        helpers.phraseapp_javascript.should_not include("https")
      end
    end

    context "phrase is disabled" do
      before(:each) do
        InContextEditor.stub(:enabled?).and_return(false)
      end

      it "should not return a thing" do
        helpers.phraseapp_javascript.should == ""
      end
    end
  end
end
