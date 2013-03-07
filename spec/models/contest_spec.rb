require 'spec_helper'

describe Contest do
  it {should validate_presence_of(:bounty)}
  it {should validate_presence_of(:deadline)}
  it {should validate_presence_of(:description)}
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:user)}
end
