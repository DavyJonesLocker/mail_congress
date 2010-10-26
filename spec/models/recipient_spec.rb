require 'spec_helper'

describe Recipient do
  it { should belong_to :letter }
  it { should belong_to :legislator }
end
