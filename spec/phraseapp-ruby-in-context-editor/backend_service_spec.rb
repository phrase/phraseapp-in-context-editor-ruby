require 'spec_helper'
require 'phraseapp-ruby-in-context-editor'
require 'phraseapp-ruby-in-context-editor/adapters/i18n'
require 'phraseapp-ruby-in-context-editor/backend_service'

describe InContextEditor::BackendService do
  let(:phrase_service){ InContextEditor::BackendService.new }

  describe "#translate" do
    let(:key_name) { "foo.bar" }
    let(:i18n_translation) { stub }
    let(:key_is_blacklisted){ false }
    let(:key_is_ignored) { false }

    before(:each) do
      InContextEditor.config.prefix = "{{__"
      InContextEditor.config.suffix = "__}}"
      I18n.stub(:translate_without_phrase).with(key_name).and_return(i18n_translation)
      phrase_service.stub(:has_blacklist_entry_for_key?){ key_is_blacklisted }
      phrase_service.stub(:key_is_ignored?) { key_is_ignored }
    end

    subject { phrase_service.translate(*args) }

    context "phrase is enabled" do
      before(:each) do
        InContextEditor.stub(:disabled?){ false }
      end

      context "key is blacklisted" do
        let(:args){ [key_name] }
        let(:key_is_blacklisted){ true }

        it { should eql i18n_translation }
      end

      context "key is ignored" do
        let(:args) { [key_name] }
        let(:key_is_ignored) { true }

        it { should eql i18n_translation }
      end

      context "resolve: false given as argument" do
        let(:args){ [key_name, resolve: false] }

        before(:each) do
          I18n.stub(:translate_without_phrase).with(key_name, resolve: false).and_return(i18n_translation)
        end

        it { should eql i18n_translation }
      end

      context "resolve: true given as argument" do
        let(:args){ [key_name, resolve: true] }

        it { should be_a String }
        it { should eql '{{__phrase_foo.bar__}}' }
      end

      context "key is not blacklisted" do
        let(:args){ [key_name] }
        let(:key_is_blacklisted){ false }

        it { should be_a InContextEditor::Delegate::I18n }
        it { should eql '{{__phrase_foo.bar__}}' }
      end

      describe "different arguments given" do
        context "default array given" do
          let(:args){ [:key, { :default => [:first_fallback, :second_fallback] }] }
          it { VCR.use_cassette('fetch list of keys filtered by fallback key names') { should eql '{{__phrase_key__}}' }}
        end

        context "default string given" do
          let(:args){ [:key, { :default => 'first fallback' }] }

          it { should eql '{{__phrase_key__}}' }
        end

        context "scope array given" do
          let(:context_key_translation){ stub }
          let(:args){ [:key, { :scope => [:context] }] }

          it { should eql '{{__phrase_context.key__}}' }
        end
      end
    end

    context "phrase is disabled" do
      let(:args) { [key_name] }

      before(:each) do
        InContextEditor.stub(:disabled?){ true }
      end

      it { should eql i18n_translation }

      context "given arguments other than key_name" do
        let(:args){ [key_name, locale: :ru] }
        let(:ru_translation){ stub }

        before(:each) do
          I18n.stub(:translate_without_phrase).with(key_name, locale: :ru){ ru_translation }
        end

        it { should eql ru_translation }
      end

      describe "different arguments given" do
        before(:each) do
          I18n.unstub(:translate_without_phrase)
        end

        context "default array given" do
          let(:args) { [:key, { :default => [:first_fallback, :second_fallback] }] }

          specify { subject.should eql "translation missing: en.key" }
        end

        context "default string given" do
          let(:args) { [:key, { :default => 'first fallback' }] }

          it { should eql 'first fallback' }
        end

        context "scope array given" do
          let(:context_key_translation) { stub }
          let(:args) { [:key, { :scope => [:context] }] }

          specify { subject.should eql "translation missing: en.context.key" }
        end
      end
    end
  end

  describe "#has_blacklist_entry_for_key?(key)" do
    let(:key){ 'foo.blacklisted' }
    subject { phrase_service.send(:has_blacklist_entry_for_key?, key) }

    before(:each) do
      phrase_service.stub(:blacklisted_keys){ blacklisted_keys }
    end

    context "blacklisted_keys contain key" do
      let(:blacklisted_keys){ [key] }
      it { should be_truthy }
    end

    context "key is blacklisted (using wildcards)" do
      let(:blacklisted_keys){ ["foo.black*"] }
      it { should be_truthy }
    end

    context "if no blacklisted_keys" do
      let(:blacklisted_keys){ [] }
      it { should be_falsey }
    end
  end

  describe "#key_is_ignored?(key)" do
    let(:key) { 'foo.ignored' }

    subject { phrase_service.send(:key_is_ignored?, key) }

    before(:each) do
      InContextEditor.config.ignored_keys = ignored_keys
    end

    context "blacklisted_keys contain key" do
      let(:ignored_keys) { ["foo.ignored"] }

      it { should be_truthy }
    end

    context "key is ignores (using wildcards)" do
      let(:ignored_keys) { ["foo.*"] }

      it { should be_truthy }
    end

    context "if no keys are ignored" do
      let(:ignored_keys) { [] }

      it { should be_falsey }
    end
  end

  describe "#blacklisted_keys" do
    subject { phrase_service.send(:blacklisted_keys) }

    it { VCR.use_cassette('fetch list of blacklisted keys') { should eql ["faker*"] } }

    describe "memoizing the blacklisted_keys" do
      specify {
        VCR.use_cassette('fetch list of blacklisted keys') do
          old_id = phrase_service.send(:blacklisted_keys).object_id
          old_id.should eql subject.object_id
        end
      }
    end
  end

  describe '#normalized_key' do
    subject { phrase_service.send(:normalized_key, args) }

    context 'default case' do
      let(:args) { ['my.key', {}] }
      it { should == 'my.key'}
    end

    context 'the leading dot should be removed' do
      let(:args) { ['.my.key', {}] }
      it { should == 'my.key'}
    end
  end
end
