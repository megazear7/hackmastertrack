class AddMentorProdigeeRelationship < ActiveRecord::Migration
  def change
    add_column :characters, :mentor_id, :integer
  end
end
