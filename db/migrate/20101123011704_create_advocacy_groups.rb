class CreateAdvocacyGroups < ActiveRecord::Migration
  def self.up
    create_table :advocacy_groups do |t|
      t.boolean :approved, :default => false
      t.string :name
      t.string :contact_name
      t.string :phone_number
      t.string :email
      t.text   :purpose
      t.string :website
      t.database_authenticatable

      t.timestamps
    end
  end

  def self.down
    drop_table :advocacy_groups
  end
end
