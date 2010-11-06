require 'spec_helper'

describe Payment do
  it { should validate_presence_of :street, :city, :state, :zip }
  # it { should validate_associated :credit_card }

  describe '.new' do
    before do
      @payment = Payment.new(:street => 'Main St.')
    end

    it 'assigns the hash values to the accessors' do
      @payment.street.should == 'Main St.'
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

  describe '#credit_card=' do
    before do
      @payment = Payment.new(:credit_card => { :number => 123 })
    end

    it 'creates an instance of ActiveMerchant::Billing::CreditCard' do
      @payment.credit_card.should be_instance_of(CreditCard)
    end
  end

  describe '#to_key' do
    it 'always returns nil' do
      Payment.new.to_key.should be_nil
    end
  end

  describe 'Making a payment' do
    before do
      @response = mock('Response')
      @response.stubs(:success?).returns(true)
      @gateway  = mock('PaypalGateway')
      @gateway.stubs(:purchase).returns(@response)
      ActiveMerchant::Billing::PaypalGateway.stubs(:new).returns(@gateway)
    end

    context 'when succesfull' do
      before do
        @payment = Factory.build(:payment)
      end

      context 'one letter purchased' do
        before do
          @result = @payment.make(1, {})
        end

        it 'creates a gateway' do
          @payment.gateway.should == @gateway
        end

        it 'makes a purchase' do
          @gateway.should have_received(:purchase).with(100, @payment.credit_card, @payment.options({}))
        end

        it 'should respond with success' do
          @result.should be_true
        end
      end

      context '3 letters purchased' do
        before do
          @result = @payment.make(3, {})
        end

        it 'makes a purchase' do
          @gateway.should have_received(:purchase).with(300, @payment.credit_card, @payment.options({}))
        end

      end
    end

  end

  describe '#paypal_credentials' do
    before do
      @file = mock('File')
      File.stubs(:open).returns(@file)
      YAML.stubs(:load)
      payment = Payment.new
      @credentials = payment.paypal_credentials
    end

    it 'reads from a file name chosen by the environment' do
      File.should have_received(:open).with("#{Rails.root}/config/paypal/test.yml")
    end

    it 'loads the YAML' do
      YAML.should have_received(:load).with(@file)
    end
  end

  describe '#options' do
    before do
      @payment = Factory.build(:payment)
      @options = @payment.options(:email => 'johndoe@test.com', :ip => '127.0.0.1')
    end
    
    it 'builds an options hash' do
      @options.should == {
        :email => 'johndoe@test.com',
        :billing_address => {
          :name => 'John Doe',
          :address_1 => '123 Fake St.',
          :city => 'Boston',
          :state => 'MA',
          :zip => '02127',
          :country => 'US',
        },
        :ip => '127.0.0.1'
      }
    end
  end

end
