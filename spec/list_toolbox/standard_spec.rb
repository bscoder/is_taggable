require 'spec_helper'

describe IsTaggable::ListToolbox::Standard do

  describe '.new' do
    context '...()' do
      its(:delimiter) { should == ' ' }
      its(:output_delimiter) { should == ' ' }
    end

    context '...(:delimiter => ":")' do
      subject { IsTaggable::ListToolbox::Standard.new(:delimiter => ':') }
      its(:delimiter) { should == ':' }
      its(:output_delimiter) { should == ':' }
    end

    context '...(:output_delimiter => ":")' do
      subject { IsTaggable::ListToolbox::Standard.new(:output_delimiter => ':') }
      its(:delimiter) { should == ' ' }
      its(:output_delimiter) { should == ':' }
    end
  end

  describe "#extract(str)" do
    context "[the :delimiter option wasn't set]" do
      context "when str is a single word" do
        it("should return [str]") { subject.extract('tag').should == ['tag'] }
      end

      context "when str is several space separated words" do
        it("should return list of words") { subject.extract(' tag1 tag2  tag3 ').should == ['tag1', 'tag2', 'tag3'] }
        it("should keep punctuation marks") { subject.extract('tag1, tag2').should == ['tag1,', 'tag2'] }
      end
    end

    context "[the :delimiter option was set to ':']" do
      subject { IsTaggable::ListToolbox::Standard.new(:delimiter => ':') }

      context "when str has no ':'" do
        it("should return [str]") { subject.extract('tag without colon').should == ['tag without colon'] }
      end

      context "when str has colons" do
        it("should return list of substrings between colons") { subject.extract('tag 1:tag 2:tag 3').should == ['tag 1', 'tag 2', 'tag 3'] }
        it("should keep spaces and punctuation marks") { subject.extract('tag1,:  tag2').should == ['tag1,', '  tag2'] }
      end
    end

    context "[the :delimiter option was set to regexp]" do
      subject { IsTaggable::ListToolbox::Standard.new(:delimiter => /,+/) }

      context "when str has no maching delimiters" do
        it("should return [str]") { subject.extract('tag without comma').should == ['tag without comma'] }
      end

      context "when str has matching delimiters" do
        it("should return list of substrings between regexp matches") { subject.extract('tag 1,,,tag 2,tag 3').should == ['tag 1', 'tag 2', 'tag 3'] }
        it("should keep spaces and punctuation marks") { subject.extract('tag1,:  tag2').should == ['tag1', ':  tag2'] }
      end
    end
  end

  describe "#join(tag_list)" do
    subject { IsTaggable::ListToolbox::Standard.new(:output_delimiter => ':') }

    it("should join tag_list, separating tags with output_delimiter") { subject.join(['tag1', 'tag2']).should == 'tag1:tag2' }
  end

end
