require 'spec_helper'

describe IsTaggable do

  subject { Class.new{ extend IsTaggable } }

  describe ".configure_tag_list" do
    context "...()" do
      it "should set list_toolbox to an instance of IsTaggable::ListToolbox::Standard" do
        subject.configure_tag_list
        subject.list_toolbox.should be_instance_of(IsTaggable::ListToolbox::Standard)
      end
    end

    context "...(:style)" do
      it "should set list_toolbox to an instance of IsTaggable::ListToolbox::<style>" do
        subject.configure_tag_list(:youtube)
        subject.list_toolbox.should be_instance_of(IsTaggable::ListToolbox::Youtube)
      end
    end

    context "...(:style, {options})" do
      it "should set list_toolbox to IsTaggable::ListToolbox::<style>.new({options})" do
        IsTaggable::ListToolbox::Standard.expects(:new).with(:delimiter => ':')
        subject.configure_tag_list(:standard, :delimiter => ':')
      end
    end

    context "...(object)" do
      it "should set list_toolbox = object" do
        toolbox = Object.new
        subject.configure_tag_list(toolbox)
        subject.list_toolbox.should == toolbox
      end
    end
  end

end
