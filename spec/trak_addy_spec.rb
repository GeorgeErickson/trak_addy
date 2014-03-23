require 'spec_helper'
require 'trak_addy'

describe TrakAddy do
  it "should have a VERSION constant" do
    subject.const_get('VERSION').should_not be_empty
  end
end
