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
      @payment.first_name.should == @letter.name_first
      @payment.last_name.should  == @letter.name_last
      @payment.street.should    == @letter.street
      @payment.city.should      == @letter.city
      @payment.state.should     == @letter.state
      @payment.zip.should       == @letter.zip
    end
  end

  describe '#enqueue_print_job' do
    before do
      @letter = Letter.new
      @letter.stubs(:id).returns(1)
      @letter.enqueue_print_job
    end

    it 'will push a new print job to Resque' do
      Letter.should have_queued(@letter.id, :print)
    end
  end
end
