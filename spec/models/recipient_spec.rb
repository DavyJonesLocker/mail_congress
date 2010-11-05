require 'spec_helper'

describe Recipient do
  it { should belong_to :letter }
  it { should belong_to :legislator }

  describe '#css_class' do
    context 'when not selected' do
      it 'class will be "monochrome"' do
        Recipient.new.css_class.should == 'monochrome'
      end
    end

    context 'when selected' do
      it 'class will be "color"' do
        Recipient.new(:selected => true).css_class.should == 'color'
      end
    end
  end
end
