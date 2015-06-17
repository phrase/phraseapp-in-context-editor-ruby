require 'spec_helper'

require 'phraseapp-ruby-in-context-editor'
require 'phraseapp-ruby-in-context-editor/delegate'

describe InContextEditor::Delegate do
  describe InContextEditor::Delegate::Base do
    subject { InContextEditor::Delegate::Base.new }

    it { should be_a_kind_of String }
  end
end
