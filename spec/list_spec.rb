require 'spec_helper'

describe IsTaggable::List do

  let(:testable_toolbox) do
    class IsTaggable::ListToolbox::Test
      def join(l); return l.join + '+joined'; end
      def extract(s); return ["#{s}+extracted"]; end
      def normalize(t); return "#{t}+normalized"; end
      def valid?(t); return true; end
    end
    IsTaggable::ListToolbox::Test.new
  end

  describe ".new" do
    context "...(list, toolbox)" do
      subject { IsTaggable::List.new(["1", "2", "3"], testable_toolbox) }
      it("should create a new instance of IsTaggable::List") { subject.is_a?(IsTaggable::List) }
      it("should create a new instance, which is == list (using default toolbox)") { subject.should == ['1', '2', '3'] }
    end

    context "...(list)" do
      subject { IsTaggable::List.new(["1", "2", "3"]) }

      it("should create a new instance of IsTaggable::List") { subject.is_a?(IsTaggable::List) }
      it("should create a new instance, which is == list (using default toolbox)") { subject.should == ['1', '2', '3'] }
    end
  end

  describe '#to_s' do
    it("should delegate to ListToolbox#join") { IsTaggable::List.new(['xxx'], testable_toolbox).to_s.should == 'xxx+joined' }
  end

  describe '#normalize_tags! (using methods from toolbox)' do
    subject { IsTaggable::List.new(['1', '2', '2'], testable_toolbox).tap(&:normalize_tags!) }

    it("should split and normalize each item and uniqualize the list") { 
      subject.should == ['1+extracted+normalized', '2+extracted+normalized'] 
    }

    it("should reject invalid items") { 
      testable_toolbox.stubs(:valid? => false); 
      subject.should == [] 
    }

    it("should reject invalid items after splitting and normalizing them and not before") { 
      def testable_toolbox.valid?(t); t == '1+extracted+normalized'; end
      subject.should == ['1+extracted+normalized'] 
    }

    it("should not renormalize already normalized tags") { 
      subject.normalize_tags! # normalize second time
      subject.should == ['1+extracted+normalized', '2+extracted+normalized'] 
    }

    it("should not normalize frozen tags") { 
      subject << '3'
      subject.freeze_tags!
      subject.normalize_tags!
      subject.should == ['1+extracted+normalized', '2+extracted+normalized', '3'] 
    }

    it("should uniqualize even frozen tags") { 
      subject << '3' << '3'
      subject.freeze_tags!
      subject.normalize_tags!
      subject.should == ['1+extracted+normalized', '2+extracted+normalized', '3'] 
    }
  end

  describe "#freeze_tags" do
    subject { IsTaggable::List.new(['1', '2'], testable_toolbox).tap(&:freeze_tags!) }

    it("should freeze every tag") { subject.each { |item| item.should be_frozen } }
  end

end
