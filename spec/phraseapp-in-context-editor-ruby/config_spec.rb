require 'spec_helper'
require 'phraseapp-in-context-editor-ruby/config'

describe PhraseApp::InContextEditor::Config do
  subject(:config) { PhraseApp::InContextEditor::Config.new }

  describe "#enabled" do
    context "has been set" do
      it "should return the set value" do
        config.enabled = "maybe"
        config.enabled.should == "maybe"
      end
    end

    context "has not been set" do
      it "should be false by default" do
        config.enabled.should eql false
      end
    end
  end

  describe "#backend" do
    context "has been set" do
      it "should return the set value" do
        config.backend = "MyBackend"
        config.backend.should == "MyBackend"
      end
    end

    context "has not been set" do
      it "should return an instance of PhraseService by default" do
        config.backend.should be_a PhraseApp::InContextEditor::BackendService
      end
    end
  end

  describe "#prefix" do
    context "has been set" do
      it "should return the set prefix" do
        config.prefix = "##__"
        config.prefix.should == "##__"
      end
    end

    context "instance variable is not set" do
      it "should return the default prefix" do
        config.prefix.should == "{{__"
      end
    end
  end

  describe "#suffix" do
    context "has been set" do
      it "should return the set suffix" do
        config.suffix = "__##"
        config.suffix.should == "__##"
      end
    end

    context "instance variable is not set" do
      it "should return the default suffix" do
        config.suffix.should == "__}}"
      end
    end
  end

  describe "#js_host" do
    context "has been set" do
      it "should return the set js_host" do
        config.js_host = "example.com"
        config.js_host.should == "example.com"
      end
    end

    context "instance variable is not set" do
      it "should return the default host" do
        config.js_host.should == "phraseapp.com"
      end
    end
  end

  describe "#js_use_ssl" do
    context "has been set" do
      it "should return the set js_host" do
        config.js_use_ssl = "maybe"
        config.js_use_ssl.should == "maybe"
      end
    end

    context "instance variable is not set" do
      it "should return true as default" do
        config.js_use_ssl.should be_truthy
      end
    end
  end

  describe "#cache_key_segments_initial" do
    context "has been set" do
      it "should return the cache_key_segments_initial" do
        config.cache_key_segments_initial = ["foo", "bar"]
        config.cache_key_segments_initial.should == ["foo", "bar"]
      end
    end

    context "instance variable is not set" do
      it "should return an array" do
        config.cache_key_segments_initial.should be_an(Array)
      end
    end
  end

  describe "#cache_lifetime" do
    context "has been set" do
      it "should return the cache_lifetime" do
        config.cache_lifetime = 99
        config.cache_lifetime.should == 99
      end
    end

    context "instance variable is not set" do
      it "should return 5 minutes" do
        config.cache_lifetime.should eql 300
      end
    end
  end

  describe "#ignored_keys" do
    context "has been set" do
      it "should return the cache_lifetime" do
        config.ignored_keys = ["foo"]
        config.ignored_keys.should == ["foo"]
      end
    end

    context "instance variable is not set" do
      specify { config.ignored_keys.should eql [] }
    end
  end
end
