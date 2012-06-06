require 'spec_helper'

describe IsTaggable do

  describe ".configure_tag_list" do
    context "...()" do
      it "should set list_toolbox to an instance of IsTaggable::ListToolbox::Standard" do
        IsTaggable.configure_tag_list
        IsTaggable.list_toolbox.should be_instance_of(IsTaggable::ListToolbox::Standard)
      end
    end

    context "...(:style)" do
      it "should set list_toolbox to an instance of IsTaggable::ListToolbox::<style>" do
        IsTaggable.configure_tag_list(:youtube)
        IsTaggable.list_toolbox.should be_instance_of(IsTaggable::ListToolbox::Youtube)
      end
    end

    context "...(:style, {options})" do
      it "should set list_toolbox to IsTaggable::ListToolbox::<style>.new({options})" do
        IsTaggable::ListToolbox::Standard.expects(:new).with(:delimiter => ':')
        IsTaggable.configure_tag_list(:standard, :delimiter => ':')
      end
    end

    context "...(object)" do
      it "should set list_toolbox = object" do
        toolbox = Object.new
        IsTaggable.configure_tag_list(toolbox)
        IsTaggable.list_toolbox.should == toolbox
      end
    end
  end
end

