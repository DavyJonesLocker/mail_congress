require 'spec_helper'

describe RecipientLegislator do
  it { should belong_to :letter }
  it { should belong_to :legislator }
end
