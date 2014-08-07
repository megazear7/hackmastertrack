class Specialization < ActiveRecord::Base
  belongs_to :character
  belongs_to :item
  attr_accessor :bp_cost
end
