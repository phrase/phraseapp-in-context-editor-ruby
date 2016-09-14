require 'spec_helper'
require 'phraseapp-in-context-editor-ruby/config'

describe PhraseApp::InContextEditor::Config do
  subject(:config) { PhraseApp::InContextEditor::Config.new }

  after(:each) do
    PhraseApp::InContextEditor::Config.reset_to_defaults!
  end

  it "should return the default option when no specific value assigned" do
    config = PhraseApp::InContextEditor::Config.new
    config.project_id.should eql nil
    PhraseApp::InContextEditor::Config.project_id.should eql nil
    PhraseApp::InContextEditor::Config.project_id = "foo"
    PhraseApp::InContextEditor::Config.project_id.should eql "foo"
    config.project_id.should eql "foo"
    config.project_id = "bar"
    config.project_id.should eql "bar"
    PhraseApp::InContextEditor::Config.project_id = "foo"
  end

  describe "#self.reset_to_defaults!" do
    it "should reset the class level variables to their defaults" do
      PhraseApp::InContextEditor::Config.project_id = "foo"
      PhraseApp::InContextEditor::Config.project_id.should eql "foo"
      PhraseApp::InContextEditor::Config.reset_to_defaults!
      PhraseApp::InContextEditor::Config.project_id.should eql nil
    end
  end
end
