require 'spec_helper'

describe InContextEditor do
  describe "#self.enabled?" do
    it "should return true if phrase is enabled" do
      InContextEditor.config.stub(:enabled).and_return(true)
      InContextEditor.enabled?.should be_truthy
    end

    it "should return false if phrase is not enabled" do
      InContextEditor.config.stub(:enabled).and_return(false)
      InContextEditor.enabled?.should be_falsey
    end
  end

  describe "#self.disabled?" do
    it "should return true if phrase is disabled" do
      InContextEditor.config.stub(:enabled).and_return(false)
      InContextEditor.disabled?.should be_truthy
    end

    it "should return false if phrase is not disabled" do
      InContextEditor.config.stub(:enabled).and_return(true)
      InContextEditor.disabled?.should be_falsey
    end
  end

  describe "self.configure" do
    before(:each) do
      InContextEditor.configure do |config|
        config.prefix = "my prefix"
        config.suffix = "my suffix"
      end
    end

    specify { InContextEditor.prefix.should eql("my prefix") }
    specify { InContextEditor.suffix.should eql("my suffix") }
  end
end
