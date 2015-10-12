require 'spec_helper'
require 'phraseapp-in-context-editor-ruby'
require 'phraseapp-in-context-editor-ruby/displayable_key_identifier'
require 'phraseapp-in-context-editor-ruby/fallback_keys_fetcher'

describe PhraseApp::InContextEditor::DisplayableKeyIdentifier do
  let(:identifier) { PhraseApp::InContextEditor::DisplayableKeyIdentifier.new(PhraseApp::InContextEditor::ApiWrapper.new) }

  describe "#identify(key_name, options)" do
    let(:key) { "foo.main" }
    let(:options) { {} }
    let(:keys) { [] }

    subject{ identifier.identify(key, options)}

    before(:each) do
      allow(PhraseApp::InContextEditor::FallbackKeysFetcher).to receive(:extract_fallback_keys).with(key, options).and_return(["foo.fallback1", "foo.fallback2"])
      allow(identifier).to receive(:find_keys_within_phraseapp).and_return(keys)
    end

    context "standard key can be found via phrase service" do
      let(:keys) { ["foo.main"] }

      it{ is_expected.to eq "foo.main" }
    end

    context "standard key cannot be found but first fallback is available" do
      let(:keys) { ["foo.fallback1", "foo.fallback2"] }

      it { is_expected.to eq "foo.fallback1" }
    end

    context "standard key cannot be found but second fallback is available" do
      let(:keys) { ["foo.fallback2"] }

      it { is_expected.to eq "foo.fallback2" }
    end

    context "no key can be cound via phrase service" do

      it { is_expected.to eq "foo.main" }
    end
  end

  describe "#find_keys_within_phraseapp(key_names)" do
    let(:key_names) { ["foo", "bar", "baz"] }
    let(:keys_from_api) { [] }
    let(:pre_cached) { [] }
    let(:pre_fetched) { [] }

    subject { identifier.send(:find_keys_within_phraseapp, key_names) }

    before(:each) do
      allow(identifier).to receive(:key_names_returned_from_api_for).and_return(keys_from_api)
      allow(identifier.key_names_cache).to receive(:pre_cached).and_return(pre_cached)
      allow(identifier.key_names_cache).to receive(:pre_fetched).and_return(pre_fetched)
    end

    it { is_expected.to be_an(Array) }

    context "some keys are prefetched" do
      let(:pre_fetched) { ["foo", "bar"] }
      let(:pre_cached) { ["foo"] }

      context "api returns additional results" do
        let(:keys_from_api) { ["baz"] }

        it { is_expected.to eq ["foo", "baz"] }
      end

      context "api returns no results" do
        let(:keys_from_api) { [] }

        it { is_expected.to eq ["foo"] }
      end
    end

    context "no keys are prefetched" do
      let(:pre_fetched) { [] }
      let(:pre_cached) { [] }

      context "api returns results" do
        let(:keys_from_api) { ["baz"] }

        it { is_expected.to eq ["baz"] }
      end

      context "api returns no results" do
        let(:keys_from_api) { [] }

        it { is_expected.to eq [] }
      end
    end
  end


end