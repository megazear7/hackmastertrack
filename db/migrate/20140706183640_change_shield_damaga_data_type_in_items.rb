class ChangeShieldDamagaDataTypeInItems < ActiveRecord::Migration
  def change
    change_column :items, :shield_damage, :string
  end
end
