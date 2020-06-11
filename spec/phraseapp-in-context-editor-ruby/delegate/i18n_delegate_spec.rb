require 'spec_helper'
require 'phraseapp-in-context-editor-ruby'
require 'phraseapp-in-context-editor-ruby/delegate/i18n_delegate'

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

  describe "missing methods" do
    let(:delegate) { PhraseApp::InContextEditor::Delegate::I18nDelegate.new(key) }
    let(:i18n_translation) { [] }

    before(:each) do
      allow(PhraseApp::InContextEditor::Delegate::Base).to receive(:log)
      allow(I18n).to receive(:translate_without_phraseapp).and_return("i18n_translation")
    end

    context "translation is a string", vcr: {cassette_name: "translation is a string", match_requests_on: [:method, :uri, :body]} do
      let(:key) { "foo" }

      context "#each |key,value|" do
        subject { delegate.each { |key,value| } }
        specify { expect { subject }.to raise_error NoMethodError }
      end

      context "#each |key|" do
        subject { delegate.each { |key| } }
        specify { expect { subject }.to raise_error NoMethodError }
      end

      context "#keys" do
        subject { delegate.keys }
        specify { expect { subject }.to raise_error NoMethodError }
      end

      context "#map" do
        subject { delegate.map { |i| } }
        specify { expect { subject }.to raise_error NoMethodError }
      end

      context "#to_ary" do
        subject { delegate.to_ary }
        specify { expect { subject }.to raise_error NoMethodError }
      end
    end

    context "translation is a subhash", vcr: {cassette_name: "translation is a subhash", record: :new_episodes, match_requests_on: [:method, :uri, :body]} do
      let(:key) { "nested.bar" }

      context "#each |key,value|" do
        subject { result = nil; delegate.each { |key,value| result = [key, value] }; result }
        it { is_expected.to eql [:def, "def ipsum"] }
      end

      context "#each |key|" do
        subject { result = nil; delegate.each { |key| result = key }; result }
        it { is_expected.to eql [:def, "def ipsum"] }
      end

      context "#keys" do
        subject { delegate.keys }
        it { is_expected.to eql [:baz, :def] }
      end

      context "#map" do
        subject { result = nil; delegate.map { |n| result = n }; result }
        it { is_expected.to eql [:def, "def ipsum"] }
      end

      context "#to_ary" do
        subject { delegate.to_ary }
        specify { expect { subject }.to raise_error NoMethodError }
      end
    end

    context "translation is pluralized", vcr: {cassette_name: "translation is pluralized", record: :new_episodes, match_requests_on: [:method, :uri, :body]} do
      let(:key) { "plural" }

      context "#each |key,value|" do
        subject { result = nil; delegate.each { |key,value| result = [key, value] }; result }
        it { is_expected.to eql [:other, "more keys"] }
      end
    end
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
