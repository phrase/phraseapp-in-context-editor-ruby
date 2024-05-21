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

    context "phrase is enabled" do
      before(:each) do
        PhraseApp::InContextEditor.enabled = true
      end

      context "resolve: false given as argument" do
        subject { phraseapp_service.translate(key_name, resolve: false) }

        before(:each) do
          allow(I18n).to receive(:translate_without_phraseapp).with(key_name, resolve: false).and_return(i18n_translation)
        end

        it { is_expected.to eql i18n_translation }
      end

      context "resolve: true given as argument" do
        subject { phraseapp_service.translate(key_name, resolve: true) }

        it { is_expected.to be_a String }
        it { is_expected.to eql "{{__phrase_foo.bar__}}" }
      end

      describe "different arguments given" do
        context "default array given", vcr: {cassette_name: "fetch list of keys filtered by fallback key names"} do
          subject { phraseapp_service.translate(:key, default: [:first_fallback, :second_fallback]) }

          it { is_expected.to eql "{{__phrase_key__}}" }
        end

        context "default string given" do
          subject { phraseapp_service.translate(:key, default: "first fallback") }

          it { is_expected.to eql "{{__phrase_key__}}" }
        end

        context "scope array given" do
          subject { phraseapp_service.translate(:key, scope: [:context]) }
          let(:context_key_translation) { double }

          it { is_expected.to eql "{{__phrase_context.key__}}" }
        end
      end
    end

    context "phrase is disabled" do
      subject { phraseapp_service.translate(key_name) }

      before(:each) do
        PhraseApp::InContextEditor.enabled = false
      end

      it { is_expected.to eql i18n_translation }

      context "given arguments other than key_name" do
        subject { phraseapp_service.translate(key_name, locale: :ru) }
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
          subject { phraseapp_service.translate(:key, default: [:first_fallback, :second_fallback]) }

          it { is_expected.to eql "Translation missing. Options considered were:\n- en.key\n- en.first_fallback\n- en.second_fallback" }
        end

        context "default string given" do
          subject { phraseapp_service.translate(:key, default: "first fallback") }

          it { is_expected.to eql "first fallback" }
        end

        context "default string given without key" do
          subject { phraseapp_service.translate(default: "first fallback") }

          it { is_expected.to eql "first fallback" }
        end

        context "scope array given" do
          subject { phraseapp_service.translate(:key, scope: [:context]) }
          let(:context_key_translation) { double }

          it { is_expected.to eql "Translation missing: en.context.key" }
        end
      end
    end
  end

  describe "#ignored_key?" do
    let(:key_name) { "bar" }
    subject { phraseapp_service.send(:ignored_key?, key_name, scope: "foo") }

    before do
      PhraseApp::InContextEditor.config.ignored_keys = ignored_keys
    end

    context "exact key is ignored" do
      let(:ignored_keys) { %w[foo.bar baz] }

      it { is_expected.to be_truthy }
    end

    context "key with wildcard is ignored" do
      let(:ignored_keys) { %w[foo.* baz] }

      it { is_expected.to be_truthy }
    end

    context "no keys are ignored" do
      let(:ignored_keys) { [] }

      it { is_expected.to be_falsey }
    end

    context "different keys are ignored" do
      let(:ignored_keys) { %w[baz baz.foo bar.* foo] }

      it { is_expected.to be_falsey }
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

  describe "delegation of methods on translatable values" do
    let(:key) { "foo" }
    let(:options) { {} }
    let(:delegate) { phraseapp_service.translate(key, **options)}

    before(:each) do
      PhraseApp::InContextEditor.enabled = true
    end

    context "string method to decorated_key_name" do
      subject { delegate.include? "phrase_foo" }
      let(:method_return) { true }

      before(:each) do
        expect(I18n).not_to receive(:translate_without_phraseapp)
      end

      it { is_expected.to eql method_return }

      context "with an option set" do
        let(:options) { {locale: :en} }

        it { is_expected.to eql method_return }
      end
    end

    context "non-string method to original translation" do
      subject { delegate.value? 3 }

      let(:i18n_translation) { {baz: 3} }
      let(:scoped) { "bar" }
      let(:i18n_translation_scoped) { {baz: 5} }

      before(:each) do
        I18n.backend.store_translations(:en, {key => i18n_translation})
        I18n.backend.store_translations(:en, {scoped => {key => i18n_translation_scoped}})
        expect(I18n).to receive(:translate_without_phraseapp).and_call_original
      end

      it { is_expected.to eql true }

      context "with an option set" do
        let(:options) { {scope: scoped} }

        it { is_expected.to eql false }
      end
    end
  end
end
