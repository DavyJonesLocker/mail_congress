class CreateRecipientLegislators < ActiveRecord::Migration
  def self.up
    create_table :recipient_legislators do |t|
      t.integer :letter_id
      t.integer :legislator_id

      t.timestamps
    end
  end

  def self.down
    drop_table :recipient_legislators
  end
end
