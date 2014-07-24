class AddAdminLevelToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin_level, :integer
  end
end
