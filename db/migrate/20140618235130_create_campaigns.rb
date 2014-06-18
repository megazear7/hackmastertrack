class CreateCampaigns < ActiveRecord::Migration
  def change

    create_table :campaigns do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    add_column :encounters, :campaign_id, :integer

    create_table :campaigns_characters do |t|
      t.integer :campaign_id
      t.integer :character_id
    end

  end
end
