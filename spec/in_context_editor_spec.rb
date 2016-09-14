require 'spec_helper'

describe PhraseApp::InContextEditor do
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

  describe "#self.with_config(config_options={}, &block)" do
    it "should allow to set a config that is only present in a given block" do
      PhraseApp::InContextEditor.config.project_id = "old-project-id"
      PhraseApp::InContextEditor.project_id.should eql "old-project-id"
      project_id_1 = nil
      project_id_2 = nil
      PhraseApp::InContextEditor.with_config(project_id: "my-new-project-id") do
        PhraseApp::InContextEditor.with_config(project_id: "my-newest-project-id") do
          project_id_2 = PhraseApp::InContextEditor.project_id
        end

        project_id_1 = PhraseApp::InContextEditor.project_id
      end

      project_id_1.should eql "my-new-project-id"
      project_id_2.should eql "my-newest-project-id"

      PhraseApp::InContextEditor.project_id.should eql "old-project-id"
    end
  end
end
