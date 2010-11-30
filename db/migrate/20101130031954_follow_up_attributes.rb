class FollowUpAttributes < ActiveRecord::Migration
  def self.up
    change_table :letters do |t|
      t.boolean :follow_up_made, :default => false
      t.string  :follow_up_id
    end
  end

  def self.down
    remove_column :letters, :follow_up_made
    remove_column :letters, :follow_up_id
  end
end
