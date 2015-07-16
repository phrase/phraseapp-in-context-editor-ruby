require 'spec_helper'

describe PhraseApp::InContextEditor do
  describe "#self.enabled?" do
    it "should return true if phrase is enabled" do
      PhraseApp::InContextEditor.config.stub(:enabled).and_return(true)
      PhraseApp::InContextEditor.enabled?.should be_truthy
    end

    it "should return false if phrase is not enabled" do
      PhraseApp::InContextEditor.config.stub(:enabled).and_return(false)
      PhraseApp::InContextEditor.enabled?.should be_falsey
    end
  end

  describe "#self.disabled?" do
    it "should return true if phrase is disabled" do
      PhraseApp::InContextEditor.config.stub(:enabled).and_return(false)
      PhraseApp::InContextEditor.disabled?.should be_truthy
    end

    it "should return false if phrase is not disabled" do
      PhraseApp::InContextEditor.config.stub(:enabled).and_return(true)
      PhraseApp::InContextEditor.disabled?.should be_falsey
    end
  end

  describe "self.configure" do
    before(:each) do
      PhraseApp::InContextEditor.configure do |config|
        config.prefix = "my prefix"
        config.suffix = "my suffix"
      end
    end

    specify { PhraseApp::InContextEditor.prefix.should eql("my prefix") }
    specify { PhraseApp::InContextEditor.suffix.should eql("my suffix") }
  end
end
