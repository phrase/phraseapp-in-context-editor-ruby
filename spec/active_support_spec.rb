require "spec_helper"

describe ActiveSupport::Inflector do
  describe "#safe_constantize" do
    it "treats regex characters in an autoload failure as literal text" do
      allow(described_class).to receive(:constantize).with("Missing[").and_raise(
        LoadError, "Unable to autoload constant Missing["
      )

      expect(described_class.safe_constantize("Missing[")).to be_nil
    end

    it "returns nil for an autoload failure matching the first constant segment" do
      allow(described_class).to receive(:constantize).with("::Missing::Nested").and_raise(
        LoadError, "Unable to autoload constant Missing"
      )

      expect(described_class.safe_constantize("::Missing::Nested")).to be_nil
    end

    it "re-raises an autoload failure that only matches as a regular expression" do
      allow(described_class).to receive(:constantize).with("Missing.Name").and_raise(
        LoadError, "Unable to autoload constant MissingXName"
      )

      expect { described_class.safe_constantize("Missing.Name") }.to raise_error(
        LoadError, "Unable to autoload constant MissingXName"
      )
    end
  end
end
