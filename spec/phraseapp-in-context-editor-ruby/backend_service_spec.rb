require 'spec_helper'
require 'phraseapp-in-context-editor-ruby'
require 'phraseapp-in-context-editor-ruby/adapters/i18n'
require 'phraseapp-in-context-editor-ruby/backend_service'

describe PhraseApp::InContextEditor::BackendService do
  let(:phraseapp_service){ PhraseApp::InContextEditor::BackendService.new }

  before(:each) do
    PhraseApp::InContextEditor::Config.access_token = "test-token"
  end

  describe "#translate" do
    let(:key_name) { "foo.bar" }
    let(:i18n_translation) { double }
    let(:key_is_blacklisted){ false }
    let(:key_is_ignored) { false }

    before(:each) do
      PhraseApp::InContextEditor.config.prefix = "{{__"
      PhraseApp::InContextEditor.config.suffix = "__}}"
      allow(I18n).to receive(:translate_without_phraseapp).with(key_name).and_return(i18n_translation)
      allow(phraseapp_service).to receive(:has_blacklist_entry_for_key?){ key_is_blacklisted }
      allow(phraseapp_service).to receive(:key_is_ignored?) { key_is_ignored }
    end

    subject { phraseapp_service.translate(*args) }

    context "phrase is enabled" do
      before(:each) do
        PhraseApp::InContextEditor.enabled = true
      end

      context "key is blacklisted" do
        let(:args){ [key_name] }
        let(:key_is_blacklisted){ true }

        it { is_expected.to eql i18n_translation }
      end

      context "key is ignored" do
        let(:args) { [key_name] }
        let(:key_is_ignored) { true }

        it { is_expected.to eql i18n_translation }
      end

      context "resolve: false given as argument" do
        let(:args){ [key_name, resolve: false] }

        before(:each) do
          allow(I18n).to receive(:translate_without_phraseapp).with(key_name, resolve: false).and_return(i18n_translation)
        end

        it { is_expected.to eql i18n_translation }
      end

      context "resolve: true given as argument" do
        let(:args){ [key_name, resolve: true] }

        it { is_expected.to be_a String }
        it { is_expected.to eql '{{__phrase_foo.bar__}}' }
      end

      context "key is not blacklisted" do
        let(:args){ [key_name] }
        let(:key_is_blacklisted){ false }

        it { is_expected.to be_a PhraseApp::InContextEditor::Delegate::I18nDelegate }
        it { is_expected.to eql '{{__phrase_foo.bar__}}' }
      end

      describe "different arguments given" do
        context "default array given", vcr: {cassette_name: 'fetch list of keys filtered by fallback key names'} do
          let(:args){ [:key, { :default => [:first_fallback, :second_fallback] }] }
          it { is_expected.to eql '{{__phrase_key__}}' }
        end

        context "default string given" do
          let(:args){ [:key, { :default => 'first fallback' }] }

          it { is_expected.to eql '{{__phrase_key__}}' }
        end

        context "scope array given" do
          let(:context_key_translation){ double }
          let(:args){ [:key, { :scope => [:context] }] }

          it { is_expected.to eql '{{__phrase_context.key__}}' }
        end
      end
    end

    context "phrase is disabled" do
      let(:args) { [key_name] }

      before(:each) do
        PhraseApp::InContextEditor.enabled = false
      end

      it { is_expected.to eql i18n_translation }

      context "given arguments other than key_name" do
        let(:args){ [key_name, locale: :ru] }
        let(:ru_translation){ double }

        before(:each) do
          allow(I18n).to receive(:translate_without_phraseapp).with(key_name, locale: :ru){ ru_translation }
        end

        it { is_expected.to eql ru_translation }
      end

      describe "different arguments given" do
        before(:each) do
          allow(I18n).to receive(:translate_without_phraseapp).and_call_original
        end

        context "default array given" do
          let(:args) { [:key, { :default => [:first_fallback, :second_fallback] }] }

          it { is_expected.to eql "translation missing: en.key" }
        end

        context "default string given" do
          let(:args) { [:key, { :default => 'first fallback' }] }

          it { is_expected.to eql 'first fallback' }
        end

        context "scope array given" do
          let(:context_key_translation) { double }
          let(:args) { [:key, { :scope => [:context] }] }

          it { is_expected.to eql "translation missing: en.context.key" }
        end

        context "scope array given in rails 3 style" do
          let(:context_key_translation) { double }
          let(:args) { [:key, **{ :scope => [:context] }] }

          it { is_expected.to eql "translation missing: en.context.key" }
        end
      end
    end
  end

  describe "#has_blacklist_entry_for_key?(key)" do
    let(:key){ 'foo.blacklisted' }
    subject { phraseapp_service.send(:has_blacklist_entry_for_key?, key) }

    before(:each) do
      allow(phraseapp_service).to receive(:blacklisted_keys){ blacklisted_keys }
    end

    context "blacklisted_keys contain key" do
      let(:blacklisted_keys){ [key] }
      it { is_expected.to be_truthy }
    end

    context "key is blacklisted (using wildcards)" do
      let(:blacklisted_keys){ ["foo.black*"] }
      it { is_expected.to be_truthy }
    end

    context "if no blacklisted_keys" do
      let(:blacklisted_keys){ [] }
      it { is_expected.to be_falsey }
    end
  end

  describe "#key_is_ignored?(key)" do
    let(:key) { 'foo.ignored' }

    subject { phraseapp_service.send(:key_is_ignored?, key) }

    before(:each) do
      PhraseApp::InContextEditor.config.ignored_keys = ignored_keys
    end

    context "blacklisted_keys contain key" do
      let(:ignored_keys) { ["foo.ignored"] }

      it { is_expected.to be_truthy }
    end

    context "key is ignores (using wildcards)" do
      let(:ignored_keys) { ["foo.*"] }

      it { is_expected.to be_truthy }
    end

    context "if no keys are ignored" do
      let(:ignored_keys) { [] }

      it { is_expected.to be_falsey }
    end
  end

  describe "#blacklisted_keys", vcr: {cassette_name: 'fetch list of blacklisted keys'} do
    subject { phraseapp_service.send(:blacklisted_keys) }

    it { is_expected.to eql ["faker*"] }

    describe "memoizing the blacklisted_keys" do
      specify do
        old_id = phraseapp_service.send(:blacklisted_keys).object_id
        expect(old_id).to eql subject.object_id
      end
    end
  end

  describe '#normalized_key' do
    subject { phraseapp_service.send(:normalized_key, args) }

    context 'default case' do
      let(:args) { ['my.key', {}] }
      it { is_expected.to eql 'my.key'}
    end

    context 'the leading dot should be removed' do
      let(:args) { ['.my.key', {}] }
      it { is_expected.to eql 'my.key'}
    end
  end
end
