require 'spec_helper'

describe Payment do

  describe '.new' do
    before do
      @payment = Payment.new(:firstname => "John")
    end

    it 'assigns the hash values to the accessors' do
      @payment.firstname.should == "John"
    end
  end

  describe '.model_name' do
    before do
      @name = Payment.model_name
    end

    it 'is "Payment"' do
      @name.should == 'Payment'
    end

    it 'is an instance of ActiveModel::Name' do
      @name.should be_instance_of(ActiveModel::Name)
    end
  end

  describe '#to_key' do
    it 'always returns nil' do
      Payment.new.to_key.should be_nil
    end
  end

end
