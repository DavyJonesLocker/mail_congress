require 'spec_helper'

describe Letter do
  it { should have_many :recipient_legislators }
  it { should have_many :recipients, :through => :recipient_legislators, :source => :legislator }
  it { should accept_nested_attributes_for :recipients }
end
