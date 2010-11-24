require 'spec_helper'

describe Campaign do
  it { should have_many :letters }
  it { should validate_presence_of :title }
  it { should validate_presence_of :summary }
  it { should validate_presence_of :body }
end
