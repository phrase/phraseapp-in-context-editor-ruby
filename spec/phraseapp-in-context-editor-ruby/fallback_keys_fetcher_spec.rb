require 'spec_helper'
require 'phraseapp-in-context-editor-ruby'
require 'phraseapp-in-context-editor-ruby/fallback_keys_fetcher'

describe PhraseApp::InContextEditor::FallbackKeysFetcher do

  describe "#extract_fallback_keys" do
    let(:options) { {} }
    let(:key) { "key.with.defaults" }

    subject { PhraseApp::InContextEditor::FallbackKeysFetcher.extract_fallback_keys(key, options) }

    context "when default is an array" do
      let(:options) { {:default => [:foo, :bar]} }

      it { is_expected.to eq ["foo", "bar"] }

      context "scope is given" do
        let(:options) { {default: [:foo, :bar], scope: "scopeee"} }

        it { is_expected.to eq ["scopeee.foo", "scopeee.bar"] }

        context "scope is a array" do
          let(:options) { {default: [:foo, :bar], scope: [:baz, :boo]} }

          it { is_expected.to eq ["baz.boo.foo", "baz.boo.bar"] }
        end
      end
    end

    context "when default is a symbol" do
      let(:options) { {:default => :foo} }

      it { is_expected.to eq ["foo"] }

      context "scope is given" do
        let(:options) { {default: :foo, scope: "scopeee"} }

        it { is_expected.to eq ["scopeee.foo"] }
      end
    end

    context "when no default present" do
      let(:options) { {} }

      it { is_expected.to eq [] }

      context "scope is given" do
        let(:options) { {scope: "scopeee"} }

        it { is_expected.to eq [] }
      end
    end
  end


  describe "#process_fallback_item" do
    let(:item) { :foo }
    let(:key) { "my.key" }
    let(:options) { {} }

    subject { PhraseApp::InContextEditor::FallbackKeysFetcher.process_fallback_item(item, key, options) }

    context "item is a symbol" do
      let(:item) { :foo }

      it { is_expected.to eq ["foo"] }
    end

    context "item is a string" do
      let(:item) { "foo" }

      it { is_expected.to eq [] }
    end

    context "item came from label helper" do
      let(:item) { :foo }
      let(:key) { "helpers.label.foo" }

      it { is_expected.to eq ["foo", "activerecord.attributes.foo"] }
    end

    context "item came from simple_form" do
      let(:item) { :"users.foo" }
      let(:key) { "simple_form.labels.users.foo" }

      it { is_expected.to eq ["users.foo", "activerecord.attributes.users.foo"] }
    end
  end
end