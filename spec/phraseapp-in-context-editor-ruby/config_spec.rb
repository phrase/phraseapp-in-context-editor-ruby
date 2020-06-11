require 'spec_helper'
require 'phraseapp-in-context-editor-ruby/config'

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

  describe "global config change" do
    it "should invalidate the api client to ensure that it always uses the correct access token etc" do
      first_api_client = PhraseApp::InContextEditor::Config.api_client
      PhraseApp::InContextEditor::Config.access_token = "my-new-token"
      second_api_client = PhraseApp::InContextEditor::Config.api_client
      # Hacky: Currently no better way to check api client renewal
      expect(second_api_client.object_id).not_to eql first_api_client.object_id
      expect(second_api_client.instance_eval("@credentials").send(:token)).to eql("my-new-token")
    end
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

  describe "#self.api_client" do
    it "should be generate an api client by default" do
      expect(PhraseApp::InContextEditor::Config.api_client).to be_a(PhraseApp::Client)
    end
  end
end
