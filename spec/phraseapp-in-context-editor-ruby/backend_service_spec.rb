require "spec_helper"
require "phraseapp-in-context-editor-ruby"
require "phraseapp-in-context-editor-ruby/adapters/i18n"
require "phraseapp-in-context-editor-ruby/backend_service"

describe PhraseApp::InContextEditor::BackendService do
  let(:phraseapp_service) { PhraseApp::InContextEditor::BackendService.new }

  describe "#translate" do
    let(:key_name) { "foo.bar" }
    let(:i18n_translation) { "translation for key" }

    before(:each) do
      PhraseApp::InContextEditor.config.prefix = "{{__"
      PhraseApp::InContextEditor.config.suffix = "__}}"
      allow(I18n).to receive(:translate_without_phraseapp).with(key_name).and_return(i18n_translation)
    end

    subject { phraseapp_service.translate(*args) }

    context "phrase is enabled" do
      before(:each) do
        PhraseApp::InContextEditor.enabled = true
      end

      context "resolve: false given as argument" do
        let(:args) { [key_name, resolve: false] }

        before(:each) do
          allow(I18n).to receive(:translate_without_phraseapp).with(key_name, resolve: false).and_return(i18n_translation)
        end

        it { is_expected.to eql i18n_translation }
      end

      context "resolve: true given as argument" do
        let(:args) { [key_name, resolve: true] }

        it { is_expected.to be_a String }
        it { is_expected.to eql "{{__phrase_foo.bar__}}" }
      end

      describe "different arguments given" do
        context "default array given", vcr: {cassette_name: "fetch list of keys filtered by fallback key names"} do
          let(:args) { [:key, {default: [:first_fallback, :second_fallback]}] }
          it { is_expected.to eql "{{__phrase_key__}}" }
        end

        context "default string given" do
          let(:args) { [:key, {default: "first fallback"}] }

          it { is_expected.to eql "{{__phrase_key__}}" }
        end

        context "scope array given" do
          let(:context_key_translation) { double }
          let(:args) { [:key, {scope: [:context]}] }

          it { is_expected.to eql "{{__phrase_context.key__}}" }
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
        let(:args) { [key_name, locale: :ru] }
        let(:ru_translation) { double }

        before(:each) do
          allow(I18n).to receive(:translate_without_phraseapp).with(key_name, locale: :ru) { ru_translation }
        end

        it { is_expected.to eql ru_translation }
      end

      describe "different arguments given" do
        before(:each) do
          allow(I18n).to receive(:translate_without_phraseapp).and_call_original
        end

        context "default array given" do
          let(:args) { [:key, {default: [:first_fallback, :second_fallback]}] }

          it { is_expected.to eql "Translation missing. Options considered were:\n- en.key\n- en.first_fallback\n- en.second_fallback" }
        end

        context "default string given" do
          let(:args) { [:key, {default: "first fallback"}] }

          it { is_expected.to eql "first fallback" }
        end

        context "scope array given" do
          let(:context_key_translation) { double }
          let(:args) { [:key, {scope: [:context]}] }

          it { is_expected.to eql "Translation missing: en.context.key" }
        end

        context "scope array given in rails 3 style" do
          let(:context_key_translation) { double }
          let(:args) { [:key, scope: [:context]] }

          it { is_expected.to eql "Translation missing: en.context.key" }
        end
      end
    end
  end

  describe "#normalized_key" do
    subject { phraseapp_service.send(:normalized_key, args) }

    context "default case" do
      let(:args) { ["my.key", {}] }
      it { is_expected.to eql "my.key" }
    end

    context "the leading dot should be removed" do
      let(:args) { [".my.key", {}] }
      it { is_expected.to eql "my.key" }
    end
  end
end
