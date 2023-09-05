require "spec_helper"
require "phraseapp-in-context-editor-ruby/config"

describe PhraseApp::InContextEditor::Config do
  subject(:config) { PhraseApp::InContextEditor::Config.new }

  after(:each) do
    PhraseApp::InContextEditor::Config.reset_to_defaults!
  end

  it "should return the default option when no specific value assigned" do
    config = PhraseApp::InContextEditor::Config.new
    expect(config.project_id).to eql(nil)
    expect(PhraseApp::InContextEditor::Config.project_id).to eql(nil)
    PhraseApp::InContextEditor::Config.project_id = "foo"
    expect(PhraseApp::InContextEditor::Config.project_id).to eql "foo"
    expect(config.project_id).to eql "foo"
    config.project_id = "bar"
    expect(config.project_id).to eql "bar"
    PhraseApp::InContextEditor::Config.project_id = "foo"
  end

  describe "#assign_values(config_options)" do
    it "should assign the config values to the instance" do
      config = PhraseApp::InContextEditor::Config.new
      expect(config.project_id).to eql(nil)
      config.assign_values(project_id: "foo")
      expect(config.project_id).to eql("foo")
      expect(PhraseApp::InContextEditor::Config.project_id).to eql(nil)
    end
  end

  describe "#self.reset_to_defaults!" do
    it "should reset the class level variables to their defaults" do
      PhraseApp::InContextEditor::Config.project_id = "foo"
      expect(PhraseApp::InContextEditor::Config.project_id).to eql("foo")
      PhraseApp::InContextEditor::Config.reset_to_defaults!
      expect(PhraseApp::InContextEditor::Config.project_id).to eql(nil)
    end
  end
end
