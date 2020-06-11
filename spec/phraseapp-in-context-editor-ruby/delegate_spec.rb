require 'spec_helper'

require 'phraseapp-in-context-editor-ruby'
require 'phraseapp-in-context-editor-ruby/delegate'

describe PhraseApp::InContextEditor::Delegate do
  describe PhraseApp::InContextEditor::Delegate::Base do
    subject { PhraseApp::InContextEditor::Delegate::Base.new }

    it { is_expected.to be_a_kind_of String }
  end
end
