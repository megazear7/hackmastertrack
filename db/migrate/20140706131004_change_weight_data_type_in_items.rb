class ChangeWeightDataTypeInItems < ActiveRecord::Migration
  def change
    change_column :items, :weight, :float
  end
end
