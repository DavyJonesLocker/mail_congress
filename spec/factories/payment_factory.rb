Factory.define :payment do |payment|
  payment.number              { '4149244372702504' }
  payment.month               { '10' }
  payment.year                { '2015' }
  payment.verification_value  { '000' }

  payment.first_name          { 'John' }
  payment.last_name           { 'Doe' }

  payment.street              { '123 Fake St.' }
  payment.city                { 'Boston' }
  payment.state               { 'MA' }
  payment.zip                 { '02127' }
end
