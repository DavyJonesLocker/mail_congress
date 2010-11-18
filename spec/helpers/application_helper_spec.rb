require 'spec_helper'

describe ApplicationHelper do
  describe '#cost_to_send_letters' do
    it 'special message for no recipients' do
      recipients = [Recipient.new, Recipient.new, Recipient.new]
      helper.cost_to_send_letters(recipients).should == 'Please choose to whom you wish to write'
    end

    it 'properly pluralizes for a single recipient' do
      recipients = [Recipient.new, Recipient.new(:selected => true), Recipient.new]
      helper.cost_to_send_letters(recipients).should == '$1 to send this letter'
    end

    it 'properly pluralizes for multiple recipients' do
      recipients = [Recipient.new(:selected => true), Recipient.new(:selected => true), Recipient.new]
      helper.cost_to_send_letters(recipients).should == '$2 to send these letters'
    end
  end

  describe '#final_cost' do
    it 'properly pluralizes for a single recipient' do
      helper.final_cost([1]).should == 'You will be charged $1 to send 1 letter.'
    end

    it 'properly pluralizes for multiple recipients' do
      helper.final_cost([1,2]).should == 'You will be charged $2 to send 2 letters.'
    end
  end
end
