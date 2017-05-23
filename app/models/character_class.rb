class CharacterClass < ActiveRecord::Base
  has_many :levels
  has_many :bp_cost_by_race_classes
  has_many :class_spells
  has_and_belongs_to_many :proficiencies
  has_and_belongs_to_many :talents

  has_many :character_classes_skills
  has_and_belongs_to_many :skills, through: :character_classes_skills

  include Solr

  def solrJson
    return JSON.generate({
        path: "/character_class/" + self.id.to_s,
        id: self.id.to_s,
        title: solrSanitize(self.name),
        description: solrSanitize(self.description),
        category1: "class",
        groups: [ "everyone" ]})
  end
end
