class CreateLetters < ActiveRecord::Migration
  def self.up
    create_table :letters do |t|
      t.integer :sender_id
      t.text :body
      t.boolean :printed, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :letters
  end
end
