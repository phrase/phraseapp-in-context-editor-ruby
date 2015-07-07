require 'spec_helper'
require 'phraseapp-in-context-editor-ruby/hash_flattener'

describe InContextEditor::HashFlattener do
  describe "#flatten(hash, escape, previous_key=nil, &block)" do
    subject do
      keys = []
      InContextEditor::HashFlattener.flatten(hash, escape) do |key, value|
        keys << key
      end
      keys
    end

    let(:hash) { {"foo" => "bar"} }
    let(:escape) { "." }

    it { should eql [:foo] }
  end
end
