class RemovePoleArmTypeFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :pole_arm_type
  end
end
