class ItemSet < ActiveRecord::Base
  belongs_to :character
  belongs_to :left_item, class_name: "ItemInstance", foreign_key: "left_item_id"
  belongs_to :right_item, class_name: "ItemInstance", foreign_key: "right_item_id"
  belongs_to :body_item, class_name: "ItemInstance", foreign_key: "body_item_id"
  has_and_belongs_to_many :item_instances, join_table: "item_instances_item_sets"

  def combat_rose
    equipment = {}
    equipment["left_hand"] = left_item
    equipment["right_hand"] = right_item
    equipment["body"] = body_item
    equipment["worn_items"] = item_instances
    character.calculate_combat_rose equipment
  end

  def main_hand_item
    character.handedness == "R" ? right_item : left_item
  end

  def off_hand_item
    character.handedness == "R" ? left_item : right_item
  end

  def unequiped_item_instance_location_names equiped_item, location
    item_instances = []
    self.character.item_instances.each do |item_instance|
      if item_instance.item.location == location and not equiped? item_instance and item_instance != equiped_item
        item_instances << [item_instance.actual_name, item_instance.id]
      end
    end
    item_instances.sort_by!{ |m| m[0].downcase }
  end

  def unequiped_worn_items
    item_instances = []
    self.character.item_instances.each do |item_instance|
      if item_instance.item.location != "body" and item_instance.item.location != "arm" and not equiped? item_instance
        item_instances << item_instance
      end
    end
    item_instances
  end

  def equiped? item
    equiped_ids = []
    equiped_ids << right_item.id if not right_item.nil?
    equiped_ids << left_item.id if not left_item.nil?
    equiped_ids << body_item.id if not body_item.nil?
    equiped_ids += item_instances.pluck(:id)
    equiped_ids.include? item.id
  end
end
