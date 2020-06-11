require 'spec_helper'
require 'phraseapp-in-context-editor-ruby/cache'

describe PhraseApp::InContextEditor::Cache do
  let(:cache) { PhraseApp::InContextEditor::Cache.new }
  let(:now) { Time.parse("2012-01-01 12:00:00") }
  let(:ten_minutes_ago) { Time.parse("2012-01-01 11:50:00") }
  let(:cache_key) { :foo }

  before(:each) do
    allow(PhraseApp::InContextEditor).to receive(:cache_lifetime).and_return(300)
  end

  subject { cache }

  describe "#initialize" do
    subject { PhraseApp::InContextEditor::Cache.new(lifetime: 999) }

    it { expect(subject.lifetime).to eql 999 }
  end

  describe "#cached?(cache_key)" do
    subject do
      cache_subject = nil
      Timecop.freeze(now) do
        cache_subject = cache.cached?(cache_key)
      end
      cache_subject
    end

    context "entry for that cache_key exists" do
      before(:each) do
        Timecop.freeze(now) do
          cache.set(cache_key, double)
        end
      end

      it { is_expected.to be_truthy }

      context "the entry has expired" do
        before(:each) do
          Timecop.freeze(ten_minutes_ago) do
            cache.set(cache_key, "bar")
          end
        end

        it { is_expected.to be_falsey }
      end
    end

    context "no entry for that key exists" do
      it { is_expected.to be_falsey }
    end
  end

  describe "#get(cache_key)" do
    subject { cache.get(cache_key) }

    before(:each) do
      cache.set(cache_key, "bar")
    end

    it { is_expected.to eql "bar" }
  end

  describe "#set(cache_key, value)" do
    subject { cache.get(cache_key) }

    before(:each) do
      cache.set(cache_key, "bar")
    end

    it { is_expected.to eql "bar" }
  end
end
