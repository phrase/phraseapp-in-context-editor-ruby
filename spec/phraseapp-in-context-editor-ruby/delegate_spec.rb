require 'spec_helper'

require 'phraseapp-in-context-editor-ruby'
require 'phraseapp-in-context-editor-ruby/delegate'

describe InContextEditor::Delegate do
  describe InContextEditor::Delegate::Base do
    subject { InContextEditor::Delegate::Base.new }

    it { should be_a_kind_of String }
  end
end
