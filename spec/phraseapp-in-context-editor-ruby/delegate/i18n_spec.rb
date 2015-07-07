require 'spec_helper'
require 'phraseapp-in-context-editor-ruby'
require 'phraseapp-in-context-editor-ruby/delegate/i18n'

describe InContextEditor::Delegate::I18n do
  let(:key) { "foo.bar" }
  let(:options) { {} }
  let(:original_args) { stub }
  let(:delegate) { InContextEditor::Delegate::I18n.new(key) }

  subject { delegate }

  describe "#to_s" do
    let(:key) { "foo.bar" }
    subject { delegate.to_s }

    it { should be_a String }
    it { should eql("{{__phrase_foo.bar__}}") }
  end

  describe "#camelize" do
    subject { delegate.camelize }

    it { should be_a String }
    it { should eql("{{__phrase_foo.bar__}}") }
  end

  describe "#underscore" do
    let(:key) { "FooBar" }
    subject { delegate.underscore }

    it { should be_a String }
    it { should eql("{{__phrase_FooBar__}}") }
  end

  describe "#classify" do
    let(:key) { "foo_bar" }
    subject { delegate.classify }

    it { should be_a String }
    it { should eql("{{__phrase_foo_bar__}}") }
  end

  describe "#dasherize" do
    let(:key) { "foo_bar" }
    subject { delegate.dasherize }

    it { should be_a String }
    it { should eql("{{__phrase_foo_bar__}}") }
  end

  describe "#tableize" do
    let(:key) { "foo-bar" }
    subject { delegate.tableize }

    it { should be_a String }
    it { should eql("{{__phrase_foo-bar__}}") }
  end

  describe "missing methods" do
    let(:delegate) { InContextEditor::Delegate::I18n.new(key) }
    let(:i18n_translation) { [] }

    before(:each) do
      InContextEditor::Delegate::Base.stub(:log)
      I18n.stub(:translate_without_phrase).and_return("i18n_translation")
    end

    context "translation is a string", vcr: {cassette_name: "translation is a string", record: :new_episodes, match_requests_on: [:method, :uri, :body]} do
      let(:key) { "foo" }

      context "#each |key,value|" do
        subject { delegate.each { |key,value| } }
        specify { lambda { subject }.should raise_error NoMethodError }
      end

      context "#each |key|" do
        subject { delegate.each { |key| } }
        specify { lambda { subject }.should raise_error NoMethodError }
      end

      context "#keys" do
        subject { delegate.keys }
        specify { lambda { subject }.should raise_error NoMethodError }
      end

      context "#map" do
        subject { delegate.map { |i| } }
        specify { lambda { subject }.should raise_error NoMethodError }
      end

      context "#to_ary" do
        subject { delegate.to_ary }
        specify { lambda { subject }.should raise_error NoMethodError }
      end
    end

    context "translation is a subhash", vcr: {cassette_name: "translation is a subhash", record: :new_episodes, match_requests_on: [:method, :uri, :body]} do
      let(:key) { "nested.bar" }

      context "#each |key,value|" do
        subject { result = nil; delegate.each { |key,value| result = [key, value] }; result }
        it { should == [:def, "def ipsum"] }
      end

      context "#each |key|" do
        subject { result = nil; delegate.each { |key| result = key }; result }
        it { should == [:def, "def ipsum"] }
      end

      context "#keys" do
        subject { delegate.keys }
        it { should == [:baz, :def] }
      end

      context "#map" do
        subject { result = nil; delegate.map { |n| result = n }; result }
        it { should == [:def, "def ipsum"] }
      end

      context "#to_ary" do
        subject { delegate.to_ary }
        specify { lambda { subject }.should raise_error NoMethodError }
      end
    end

    context "translation is pluralized", vcr: {cassette_name: "translation is pluralized", record: :new_episodes, match_requests_on: [:method, :uri, :body]} do
      let(:key) { "plural" }

      context "#each |key,value|" do
        subject { result = nil; delegate.each { |key,value| result = [key, value] }; result }
        it { should == [:other, "more keys"] }
      end
    end
  end

  describe "#identify_key_to_display" do
    let(:keys) { [] }

    before(:each) do
      subject.key = "foo.main"
      subject.fallback_keys = ["foo.fallback1", "foo.fallback2"]
      subject.stub(:find_keys_within_phrase).and_return(keys)
    end

    context "standard key can be found via phrase service" do
      let(:keys) { ["foo.main"] }

      it "should set the standard key as display key" do
        subject.send(:identify_key_to_display)
        subject.display_key.should == "foo.main"
      end
    end

    context "standard key cannot be found but first fallback is available" do
      let(:keys) { ["foo.fallback1", "foo.fallback2"] }

      it "should use the first fallback key as display key" do
        subject.send(:identify_key_to_display)
        subject.display_key.should == "foo.fallback1"
      end
    end

    context "standard key cannot be found but second fallback is available" do
      let(:keys) { ["foo.fallback2"] }

      it "should use the first fallback key as display key" do
        subject.send(:identify_key_to_display)
        subject.display_key.should == "foo.fallback2"
      end
    end

    context "no key can be cound via phrase service" do
      it "should set the standard key as display key" do
        subject.send(:identify_key_to_display)
        subject.display_key.should == "foo.main"
      end
    end
  end

  describe "#find_keys_within_phrase(key_names)" do
    let(:key_names) { ["foo", "bar", "baz"] }
    let(:keys_from_api) { [] }
    let(:pre_cached) { [] }
    let(:pre_fetched) { [] }
    let(:delegate) { InContextEditor::Delegate::I18n.new(key) }

    subject { delegate.send(:find_keys_within_phrase, key_names) }

    before(:each) do
      delegate.stub(key_names_returned_from_api_for: keys_from_api)
      delegate.stub(pre_cached: pre_cached)
      delegate.stub(pre_fetched: pre_fetched)
    end

    it { should be_an(Array) }

    context "some keys are prefetched" do
      let(:pre_fetched) { ["foo", "bar"] }
      let(:pre_cached) { ["foo"] }

      context "api returns additional results" do
        let(:keys_from_api) { ["baz"] }

        it { should == ["foo", "baz"]}
      end

      context "api returns no results" do
        let(:keys_from_api) { [] }

        it { should == ["foo"]}
      end
    end

    context "no keys are prefetched" do
      let(:pre_fetched) { [] }
      let(:pre_cached) { [] }

      context "api returns results" do
        let(:keys_from_api) { ["baz"] }

        it { should == ["baz"]}
      end

      context "api returns no results" do
        let(:keys_from_api) { [] }

        it { should == []}
      end
    end
  end

  describe "#covered_by_initital_caching?(key_name)" do
    let(:key_name_to_fetch) { "simple.form" }

    subject { InContextEditor::Delegate::I18n.new(key).send(:covered_by_initial_caching?, key_name_to_fetch) }

    context "key starts with expression found in InContextEditor.cache_key_segments_initial" do
      before(:each) do
        InContextEditor.config.cache_key_segments_initial = ["simple", "bar"]
      end

      it { should be_truthy }

      context "is an exact match" do
        let(:key_name_to_fetch) { "simple" }

        it { should be_truthy }
      end
    end

    context "key does not start with expression found in InContextEditor.cache_key_segments_initial" do
      before(:each) do
        InContextEditor.config.cache_key_segments_initial = ["nope"]
      end

      it { should be_falsey }
    end
  end

  describe "#extract_fallback_keys" do
    let(:options) { {} }

    before(:each) do
      subject.instance_variable_set(:@options, options)
      subject.send(:extract_fallback_keys)
    end

    context "when default is an array" do
      let(:options) { {:default => [:foo, :bar]} }

      it "should add the keys to the fallbacks" do
        subject.fallback_keys.should == ["foo", "bar"]
      end

      context "scope is given" do
        let(:options) { {default: [:foo, :bar], scope: "scopeee"} }

        it "all keys should be scoped" do
          subject.fallback_keys.should == ["scopeee.foo", "scopeee.bar"]
        end
      end
    end

    context "when default is a symbol" do
      let(:options) { {:default => :foo} }

      it "should add the key to the fallbacks" do
        subject.fallback_keys.should == ["foo"]
      end

      context "scope is given" do
        let(:options) { {default: :foo, scope: "scopeee"} }

        it "all keys should be scoped" do
          subject.fallback_keys.should == ["scopeee.foo"]
        end
      end
    end

    context "when no default is empty" do
      let(:options) { {} }

      it "should not extract a thing" do
        subject.fallback_keys.should be_empty
      end

      context "scope is given" do
        let(:options) { {scope: "scopeee"} }

        it "all keys should be scoped" do
          subject.fallback_keys.should == []
        end
      end
    end
  end

  describe "#process_fallback_item" do
    context "item is a symbol" do
      it "should add an item to the fallback keys" do
        item = :foo
        subject.send(:process_fallback_item, item)
        subject.fallback_keys.should == ["foo"]
      end
    end

    context "item is a string" do
      it "should not add an item to the fallback keys" do
        item = "foo"
        subject.send(:process_fallback_item, item)
        subject.fallback_keys.should == []
      end
    end

    context "item came from label helper" do
      it "should add the specialized activerecord.attributes fallback as well" do
        subject.key = "helpers.label.foo"
        item = :foo
        subject.send(:process_fallback_item, item)
        subject.fallback_keys.should == ["foo", "activerecord.attributes.foo"]
      end
    end

    context "item came from simple_form" do
      it "should add the activerecord.attributes fallback as well" do
        subject.key = "simple_form.labels.users.foo"
        item = :"users.foo"
        subject.send(:process_fallback_item, item)
        subject.fallback_keys.should == ["users.foo", "activerecord.attributes.users.foo"]
      end
    end
  end

  describe "#decorated_key_name" do
    it "should include the phrase prefix" do
      InContextEditor.stub(:prefix).and_return("??")
      subject.send(:decorated_key_name).start_with?("??").should be_truthy
    end

    it "should include the phrase suffix" do
      InContextEditor.stub(:suffix).and_return("!!")
      subject.send(:decorated_key_name).end_with?("!!").should be_truthy
    end

    it "should include the phrase display key" do
      subject.display_key = "my.key"
      subject.send(:decorated_key_name).should include "my.key"
    end
  end

  describe "#warm_translation_key_names_cache" do
    let(:delegate) { InContextEditor::Delegate::I18n.new(key) }
    subject { delegate.send(:cache).get(:translation_key_names) }

    before(:each) do
      delegate.stub(:prefetched_key_names).and_return(["hello", "world"])
      delegate.send(:warm_translation_key_names_cache)
    end

    it { should be_an(Array) }
    it { should include "hello" }
    it { should include "world" }
  end

  describe "#prefetched_key_names" do
    let(:delegate) { InContextEditor::Delegate::I18n.new(key) }

    subject { delegate.send(:prefetched_key_names) }

    before(:each) do
      InContextEditor.config.cache_key_segments_initial = initial_segments
    end

    context "api returned a string" do
      let(:initial_segments) { ["foo"] }

      it do 
        VCR.use_cassette('fetch list of keys filtered by key names', :record => :new_episodes, :match_requests_on => [:method, :uri, :body]) do
          should include("foo")
        end
      end
    end

    context "api returned a hash" do
      #{"bar" => "lorem"}
      let(:initial_segments) { ["bar"] }

      it do
        VCR.use_cassette('fetch list of keys filtered by key names', :record => :new_episodes, :match_requests_on => [:method, :uri, :body]) do 
          should include("bar.foo")
        end
      end
    end

    context "api returned a nested hash" do
      #{"bar" => {"baz" => "ipsum", "def" => "lorem"}}
      let(:initial_segments) { ["nested"] }

      it do
        VCR.use_cassette('fetch list of keys filtered by key names', :record => :new_episodes, :match_requests_on => [:method, :uri, :body]) do 
          should include("nested.bar.baz")
        end
      end

      it do
        VCR.use_cassette('fetch list of keys filtered by key names', :record => :new_episodes, :match_requests_on => [:method, :uri, :body]) do 
          should include("nested.bar.def")
        end
      end
    end
  end
end
