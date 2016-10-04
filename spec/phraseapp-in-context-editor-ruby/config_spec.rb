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

  describe "global config change" do
    it "should invalidate the api client to ensure that it always uses the correct access token etc" do
      first_api_client = PhraseApp::InContextEditor::Config.api_client
      PhraseApp::InContextEditor::Config.access_token = "my-new-token"
      second_api_client = PhraseApp::InContextEditor::Config.api_client
      # Hacky: Currently no better way to check api client renewal
      second_api_client.object_id.should_not == first_api_client.object_id
      second_api_client.instance_eval("@credentials").send(:token).should eql "my-new-token"
    end
  end

  describe "#assign_values(config_options)" do
    it "should assign the config values to the instance" do
      config = PhraseApp::InContextEditor::Config.new
      config.project_id.should eql nil
      config.assign_values(project_id: "foo")
      config.project_id.should eql "foo"
      PhraseApp::InContextEditor::Config.project_id.should eql nil
    end
  end

  describe "#self.reset_to_defaults!" do
    it "should reset the class level variables to their defaults" do
      PhraseApp::InContextEditor::Config.project_id = "foo"
      PhraseApp::InContextEditor::Config.project_id.should eql "foo"
      PhraseApp::InContextEditor::Config.reset_to_defaults!
      PhraseApp::InContextEditor::Config.project_id.should eql nil
    end
  end

  describe "#self.api_client" do
    it "should be generate an api client by default" do
      PhraseApp::InContextEditor::Config.api_client.should be_a(PhraseApp::Client)
    end
  end
end
