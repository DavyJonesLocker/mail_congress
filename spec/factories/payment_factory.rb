Factory.define :payment do |payment|
  payment.credit_card {
    { :number             => '4149244372702504',
      :month              => '10',
      :year               => '2015',
      :verification_value => '000',
      :first_name         => 'John',
      :last_name          => 'Doe'
    }
  }

  payment.street              { '123 Fake St.' }
  payment.city                { 'Boston' }
  payment.state               { 'MA' }
  payment.zip                 { '02127' }
end
