class AddMoreFieldsToItems < ActiveRecord::Migration
  def change
    add_column :items, :size, :string
    add_column :items, :max_range, :integer
    add_column :items, :range_short, :integer
    add_column :items, :range_medium, :integer
    add_column :items, :range_long, :integer
    add_column :items, :range_extreme, :integer
    add_column :items, :range_maximum, :integer
  end
end
