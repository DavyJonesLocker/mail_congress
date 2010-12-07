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
      @letter   = mock('Letter')
      sender    = mock('Sender')
      sender.stubs(:email).returns('email')
      @letter.stubs(:sender).returns(sender)
      @letter.stubs(:cost).returns(100)
      @letter.stubs(:valid?).returns(true)
      @letter.stubs(:to_redis!).returns('redistoken')
      @payment = Factory.build(:payment)
    end

    context 'with a credit card' do
      before do
        @letter.stubs(:payment_type).returns('credit_card')
        @gateway  = mock('PaypalGateway')
      end

      context 'succesfull' do
        before do
          @response.stubs(:success?).returns(true)
          @gateway.stubs(:purchase).returns(@response)
          ActiveMerchant::Billing::PaypalGateway.stubs(:new).returns(@gateway)
          @result = @payment.make(@letter, {:ip => '127.0.0.1'})
        end

        it 'creates a gateway' do
          @payment.gateway.should == @gateway
        end

        it 'makes a purchase' do
          @gateway.should have_received(:purchase).with(100, @payment.credit_card, @payment.options({:email => 'email', :ip => '127.0.0.1'}))
        end

        it 'returns true' do
          @result.should be_true
        end
      end

      context 'failed' do
        before do
          @response.stubs(:success?).returns(false)
          @gateway.stubs(:purchase).returns(@response)
          ActiveMerchant::Billing::PaypalGateway.stubs(:new).returns(@gateway)
          @result = @payment.make(@letter, {})
        end

        it 'returns false' do
          @result.should be_false
        end

        it 'adds a validation error' do
          @payment.errors['gateway'].should include('payment authorization failed')
        end
      end
    end

    context 'paypal' do
      before do
        @letter.stubs(:payment_type).returns('paypal')
        @response.stubs(:token).returns('123')
        @gateway = mock('PaypalExpressGateway')
      end

      context 'successful' do
        before do
          @response.stubs(:success?).returns(true)
          @gateway.stubs(:setup_purchase).returns(@response)
          @gateway.stubs(:redirect_url_for).returns('url')
          ActiveMerchant::Billing::PaypalExpressGateway.stubs(:new).returns(@gateway)
          @result = @payment.make(@letter, {:ip => '127.0.0.1', :root_url => 'root_url/'})
        end

        it 'creates a gateway' do
          @payment.gateway.should == @gateway
        end

        it 'makes a purchase' do
          @gateway.should have_received(:setup_purchase).with(100, @payment.options({:ip => '127.0.0.1', :root_url => 'root_url/'}))
        end

        it 'stores the letter attributes in Redis' do
          @letter.should have_received(:to_redis!)
        end

        it 'returns true' do
          @result.should be_true
        end
      end

      context 'failed' do
        before do
          @response.stubs(:success?).returns(false)
          @gateway.stubs(:setup_purchase).returns(@response)
          @gateway.stubs(:redirect_url_for).returns('url')
          ActiveMerchant::Billing::PaypalExpressGateway.stubs(:new).returns(@gateway)
          @result = @payment.make(@letter, {})
        end

        it 'returns false' do
          @result.should be_false
        end

        it 'adds a validation error' do
          @payment.errors['gateway'].should include('no response from Paypal')
        end
      end
    end

  end

  describe '.complete' do
    before do
      @gateway  = mock('PaypalExpressGateway')
      ActiveMerchant::Billing::PaypalExpressGateway.stubs(:new).returns(@gateway)
      @response = mock('Response')
      @gateway.stubs(:purchase).returns(@response)
      @response.stubs(:success?).returns(true)
      Payment.complete(100, :ip => 'ip', :payer_id => 'payer_id', :token => 'token')
    end

    it 'gateway makes the purchase' do
      @gateway.should have_received(:purchase).with(100, :ip => 'ip', :payer_id => 'payer_id', :token => 'token') 
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
    before { @payment = Factory.build(:payment) }
    context 'credit_card' do
      before do
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

end
