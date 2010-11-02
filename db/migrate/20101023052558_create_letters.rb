class CreateLetters < ActiveRecord::Migration
  def self.up
    create_table :letters do |t|
      t.string :email
      t.string :name_first
      t.string :name_last
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.text :body
      t.boolean :printed, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :letters
  end
end
