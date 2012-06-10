require 'spec_helper'

describe IsTaggable::ListToolbox::Base do

  describe '.new' do
    let(:callback) {
      lambda{ |tag| tag }.tap{ |l| def l.to_s; 'lambda'; end; } # callback.to_s ==> "lambda"
    }

    context '...()' do
      its(:extra_normalizer) { should be_nil }
      its(:extra_validator) { should be_nil }
    end

    context '...(:normalize_with => lambda)' do
      subject { IsTaggable::ListToolbox::Base.new(:normalize_with => callback) }
      its(:extra_normalizer) { should == callback }
      its(:extra_validator) { should be_nil }
    end

    context '...(:normalize_with => :symbol)' do
      subject { IsTaggable::ListToolbox::Base.new(:normalize_with => :downcase) }
      its(:extra_normalizer) { should be_instance_of(Proc) }
      specify("extranormalizer should be lambda of tag.<symbol>") { subject.extra_normalizer.call('TAG').should == 'tag' }
    end

    context '...(:valid_when => lambda)' do
      subject { IsTaggable::ListToolbox::Base.new(:valid_when => callback) }
      its(:extra_normalizer) { should be_nil }
      its(:extra_validator) { should == callback }
    end

    context '...(:valid_when => :symbol)' do
      subject { IsTaggable::ListToolbox::Base.new(:valid_when => :frozen?) }
      its(:extra_validator) { should be_instance_of(Proc) }
      specify("extravalidator should be lambda of tag.<symbol>") {
        subject.extra_validator.call('x').should be_false
        subject.extra_validator.call('x'.freeze).should be_true
      }
    end

    context '...(:wrong_key => :xxx)' do
      subject { IsTaggable::ListToolbox::Base.new(:wrong_key => :xxx) }
      it("should raise exception") { lambda{ subject }.should raise_error(ArgumentError) }
    end
  end

  describe '#normalize(tag)' do
    context "[the :normalize_with option wasn't set]" do
      context "when tag is just a normal word" do
        it("should return tag") { subject.normalize('tag').should == 'tag' }
      end

      context "when tag is a word with redundant spaces" do
        it("should return tag without leading spaces") { subject.normalize(' tag').should == 'tag' }
        it("should return tag without trailing spaces") { subject.normalize('tag ').should == 'tag' }
        it("should squeeze multi-space-like sequences (tabs, spaces, etc)") { subject.normalize("x\t y").should == 'x y' }
      end
    end

    context "[the :normalize_with option was set]" do
      subject { IsTaggable::ListToolbox::Base.new(:normalize_with => lambda{ |t| t.upcase }) }

      it("should normalize in the standard way and then normalize additionally with the :normalize_with normalizer") do
        subject.normalize(' a  b ').should == 'A B'
      end
    end
  end

  describe '#valid(tag)' do
    context "[the :valid_when option wasn't set]" do
      context "when tag is emtpy string" do
        it("should reject") { subject.valid?('').should be_false }
      end

      context "when tag is nil value" do
        it("should reject") { subject.valid?(nil).should be_false }
      end

      context "when tag is a normal string" do
        it("should validate") { subject.valid?('tag').should be_true }
      end
    end

    context "[the :valid_when option was set to valid when size != 1]" do
      subject { IsTaggable::ListToolbox::Base.new(:valid_when => lambda{ |t| (t || '').size != 1 }) }

      context "when tag is emtpy string" do
        it("should reject") { subject.valid?('').should be_false }
      end

      context "when tag is nil value" do
        it("should reject") { subject.valid?(nil).should be_false }
      end

      context "when tag is a 1 character string" do
        it("should reject") { subject.valid?('a').should be_false }
      end

      context "when tag is a normal string" do
        it("should validate") { subject.valid?('tag').should be_true }
      end
    end
  end

  describe "#extract(str)" do
    it("should return [str]") { subject.extract('tag').should == ['tag'] }
  end

  describe "#join(tag_list)" do
    it("should join tag_list, separating tags with spaces") { subject.join(['tag1', 'tag2']).should == 'tag1 tag2' }
  end

end
