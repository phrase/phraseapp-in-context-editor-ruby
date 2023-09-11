require "spec_helper"

describe PhraseApp::InContextEditor do
  describe "self.configure" do
    before(:each) do
      PhraseApp::InContextEditor.configure do |config|
        config.prefix = "my prefix"
        config.suffix = "my suffix"
      end
    end

    specify { expect(PhraseApp::InContextEditor.prefix).to eql("my prefix") }
    specify { expect(PhraseApp::InContextEditor.suffix).to eql("my suffix") }
  end

  describe "#self.with_config(config_options={}, &block)" do
    it "should allow to set a config that is only present in a given block" do
      PhraseApp::InContextEditor.config.project_id = "old-project-id"
      expect(PhraseApp::InContextEditor.project_id).to eql "old-project-id"
      project_id_1 = nil
      project_id_2 = nil
      PhraseApp::InContextEditor.with_config(project_id: "my-new-project-id") do
        PhraseApp::InContextEditor.with_config(project_id: "my-newest-project-id") do
          project_id_2 = PhraseApp::InContextEditor.project_id
        end

        project_id_1 = PhraseApp::InContextEditor.project_id
      end

      expect(project_id_1).to eql "my-new-project-id"
      expect(project_id_2).to eql "my-newest-project-id"
      expect(PhraseApp::InContextEditor.project_id).to eql "old-project-id"
    end
  end
end
