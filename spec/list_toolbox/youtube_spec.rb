require 'spec_helper'

describe IsTaggable::ListToolbox::Youtube do

  describe '.new()' do
    it("should return instance of IsTaggable::ListToolbox::Youtube") { subject.should be_instance_of(IsTaggable::ListToolbox::Youtube) }
  end


  describe "#extract(str)" do
    context "when str is several words separated by spaces" do
      it("should return list of words") { subject.extract('one two').should == ['one', 'two'] }
    end

    context "when str is several quoted multiword sequences separated by spaces" do
      it("should return list of words and quoted sequences") { subject.extract('"is_taggable has" "some quoted tags"').should == ['"is_taggable has"', '"some quoted tags"'] }
    end

    context "when str is several words and quoted multiword sequences separated by spaces" do
      it("should return list quoted sequences and words (FEATURE: single-word tags go before quoted sequences)") { subject.extract('"is_taggable has" some "quoted tags"').should == ['some', '"is_taggable has"', '"quoted tags"'] }
    end

    context "when str is several sequences separated by spaces" do
      it("should return list of sequences") { subject.extract("is_taggable, has tags by default").should == ['is_taggable', ' has tags by default'] }
    end

    context "when str is several sequences separated by spaces and sequences include quotation marks" do
      it("should return list of sequences and quotes should be treated as ordinary chars") { subject.extract('"To be, or not to be"').should == ['"To be', ' or not to be"'] }
    end
  end

  describe "#join(tag_list)" do
    context "when tag_list items are all words" do
      it("should return string with all the items separated by spaces") { subject.join(['one', 'two']).should == 'one two' }
    end

    context "when some of tag_list items are multiword" do
      it("should return string with all the items separated by spaces and multiword items quoted") { subject.join(['one', 'two', 'three four']).should == 'one two "three four"' }
    end
  end

  describe "#normalize" do
    it("should mostly behave like #normalize in standard toolbox") { subject.normalize('  one  two ').should == 'one two' }
    it("should also remove quotation marks") { subject.normalize('"one"').should == 'one' }
    it("should remove quotation marks BEFORE standard normalizing") { subject.normalize('" one "').should == 'one' }
  end

  describe "#valid?" do
    it("should mostly behave like #valid? in standard toolbox") { subject.valid?('').should be_false }
    it("should also invalidate one-letter words") { subject.valid?('a').should be_false }
  end

end
