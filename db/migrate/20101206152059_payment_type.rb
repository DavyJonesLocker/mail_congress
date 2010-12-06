class PaymentType < ActiveRecord::Migration
  def self.up
    add_column :letters, :payment_type, :string, :default => 'credit_card'
  end

  def self.down
    remove_column :letters, :payment_type
  end
end
