require 'spec_helper'

describe 'Tag' do

  subject { Tag.new }

  it "should require name" do
    subject.name = 'tag'
    subject.should be_valid
    subject.name = ''
    subject.should_not be_valid
  end

end
