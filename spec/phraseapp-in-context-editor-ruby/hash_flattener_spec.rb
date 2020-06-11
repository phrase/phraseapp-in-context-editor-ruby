require 'spec_helper'
require 'phraseapp-in-context-editor-ruby/hash_flattener'

describe PhraseApp::InContextEditor::HashFlattener do
  describe "#flatten(hash, escape, previous_key=nil, &block)" do
    subject do
      keys = []
      PhraseApp::InContextEditor::HashFlattener.flatten(hash, escape) do |key, value|
        keys << key
      end
      keys
    end

    let(:hash) { {"foo" => "bar"} }
    let(:escape) { "." }

    it { is_expected.to eql [:foo] }
  end
end
