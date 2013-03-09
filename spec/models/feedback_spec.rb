require 'spec_helper'

describe Feedback do
  it {should belong_to(:entry)}
  it {should belong_to(:user)}
  it {should have_one(:contest)}
  it {should validate_presence_of(:content)}
end
