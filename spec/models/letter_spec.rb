require 'spec_helper'

describe Letter do
  it { should have_many :recipients }
  it { should have_many :legislators, :through => :recipients }
  it { should accept_nested_attributes_for :recipients }

  describe '#build_payment' do
    before do
      @letter  = Factory.build(:letter)
      @payment = @letter.build_payment
    end

    it 'builds a new instance of Payment copying the proper values' do
      @payment.should be_instance_of(Payment)
      @payment.firstname.should == @letter.name_first
      @payment.lastname.should  == @letter.name_last
      @payment.street.should    == @letter.street
      @payment.city.should      == @letter.city
      @payment.state.should     == @letter.state
      @payment.zip.should       == @letter.zip
    end
  end
end
