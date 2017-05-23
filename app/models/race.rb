class Race < ActiveRecord::Base
  has_many :bp_cost_by_race_classes

  has_many :preferential_races_talents
  has_and_belongs_to_many :preferential_talents, :association_foreign_key => "talent_id", :join_table => "preferential_races_talents", :class_name => "Talent"
  has_and_belongs_to_many :talents

  has_many :races_skills
  has_and_belongs_to_many :skills, through: :races_skills

  has_and_belongs_to_many :proficiencies

  include Solr

  def solrJson
    return JSON.generate({
        path: "/race/" + self.id.to_s,
        id: self.id.to_s,
        title: solrSanitize(self.name),
        description: solrSanitize(self.description),
        category1: "race",
        groups: [ "everyone" ]})
  end

  def hit_points
    if self.name == "Dwarf"
      10
    else
      { "s" => 5,
        "m" => 10
      }[self.size]
    end
  end

  def self.find_mod race, mod
    where(name: race).each do |thisrace|
      # TODO query the database instead of looping
      mod_val = thisrace.send(mod)
      if mod_val.nil?
        return 0
      else
        return mod_val
      end
    end
    0
  end
end
