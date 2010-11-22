class CreateCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns do |t|
      t.integer :advocacy_group_id
      t.text    :body
      t.text    :summary
      t.string  :title

      t.timestamps
    end
  end

  def self.down
    drop_table :campaigns
  end
end
