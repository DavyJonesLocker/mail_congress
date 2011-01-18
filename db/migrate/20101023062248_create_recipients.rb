class CreateRecipients < ActiveRecord::Migration
  def self.up
    create_table :recipients do |t|
      t.integer :letter_id
      t.integer :legislator_id

      t.timestamps
    end
  end

  def self.down
    drop_table :recipients
  end
end
