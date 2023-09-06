require "spec_helper"
require "phraseapp-in-context-editor-ruby"
require "phraseapp-in-context-editor-ruby/delegate/i18n_delegate"

describe PhraseApp::InContextEditor::Delegate::I18nDelegate do
  let(:key) { "foo.bar" }
  let(:options) { {} }
  let(:original_args) { double }
  let(:delegate) { PhraseApp::InContextEditor::Delegate::I18nDelegate.new(key) }

  subject { delegate }

  describe "#to_s" do
    let(:key) { "foo.bar" }
    subject { delegate.to_s }

    it { is_expected.to be_a String }
    it { is_expected.to eql("{{__phrase_foo.bar__}}") }
  end

  describe "#camelize" do
    subject { delegate.camelize }

    it { is_expected.to be_a String }
    it { is_expected.to eql("{{__phrase_foo.bar__}}") }
  end

  describe "#underscore" do
    let(:key) { "FooBar" }
    subject { delegate.underscore }

    it { is_expected.to be_a String }
    it { is_expected.to eql("{{__phrase_FooBar__}}") }
  end

  describe "#classify" do
    let(:key) { "foo_bar" }
    subject { delegate.classify }

    it { is_expected.to be_a String }
    it { is_expected.to eql("{{__phrase_foo_bar__}}") }
  end

  describe "#dasherize" do
    let(:key) { "foo_bar" }
    subject { delegate.dasherize }

    it { is_expected.to be_a String }
    it { is_expected.to eql("{{__phrase_foo_bar__}}") }
  end

  describe "#tableize" do
    let(:key) { "foo-bar" }
    subject { delegate.tableize }

    it { is_expected.to be_a String }
    it { is_expected.to eql("{{__phrase_foo-bar__}}") }
  end

  describe "#decorated_key_name" do
    it "should include the phrase prefix" do
      allow(PhraseApp::InContextEditor).to receive(:prefix).and_return("??")
      expect(subject.send(:decorated_key_name).start_with?("??")).to be_truthy
    end

    it "should include the phrase suffix" do
      allow(PhraseApp::InContextEditor).to receive(:suffix).and_return("!!")
      expect(subject.send(:decorated_key_name).end_with?("!!")).to be_truthy
    end

    it "should include the phrase display key" do
      subject.display_key = "my.key"
      expect(subject.send(:decorated_key_name)).to include "my.key"
    end
  end
end
