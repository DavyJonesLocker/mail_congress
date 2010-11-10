require 'spec_helper'

describe Sender do
  it { should have_many :letters }
  it { should validate_presence_of :first_name, :last_name }
  it { should validate_presence_of :street, :city, :state, :zip }
  
  describe 'validations' do
    describe 'email' do
      context 'when blank' do
        it 'should require presence' do
          sender = Sender.new(:email => '')
          sender.valid?
          sender.errors[:email].should include("can't be blank")
        end
      end
      
      context 'when nil' do
        it 'should not require presence' do
          sender = Sender.new
          sender.valid?
          sender.errors[:email].should_not include("can't be blank")
        end
      end
    end
  end
  describe '#build_payment' do
    before do
      @sender  = Factory.build(:sender)
      @payment = @sender.build_payment
    end

    it 'builds a new instance of Payment copying the proper values' do
      @payment.should be_instance_of(Payment)
      @payment.credit_card.first_name.should == @sender.first_name
      @payment.credit_card.last_name.should  == @sender.last_name
      @payment.street.should                 == @sender.street
      @payment.city.should                   == @sender.city
      @payment.state.should                  == @sender.state
      @payment.zip.should                    == @sender.zip
    end
  end

  describe '#evelope_text' do
    before do
      @sender = Factory.build(:sender)
    end

    it 'formats the address information for printing on the evelope' do
      @sender.envelope_text.should == "John Doe\n123 Test St.\nSmallville, KS 12345"
    end
  end

  describe '#name' do
    before do
      @sender = Sender.new(:first_name => 'John', :last_name => 'Doe')
    end

    it 'is "John Doe"' do
      @sender.name.should == 'John Doe'
    end
  end
end
