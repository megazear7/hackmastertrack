class Addvariouscolumnstoraces < ActiveRecord::Migration
  def change
    add_column :races, :hpsizeadj, :integer
    add_column :races, :defadjvslarge, :integer
    add_column :races, :defadj, :integer
    add_column :races, :hideinnatsur, :integer
    add_column :races, :basemv, :float
    add_column :races, :reachadj, :float
  end
end
