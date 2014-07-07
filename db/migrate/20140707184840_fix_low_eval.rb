class FixLowEval < ActiveRecord::Migration
  def change
    rename_column :items, :low_eval, :low_avail
  end
end
