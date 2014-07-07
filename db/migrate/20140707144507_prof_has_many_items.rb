class ProfHasManyItems < ActiveRecord::Migration
  def change
    remove_column :proficiencies, :item_id, :integer
    add_column :items, :proficiency_id, :integer
  end
end
