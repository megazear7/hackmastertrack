class Proficiency < ActiveRecord::Base
  has_and_belongs_to_many :races
  has_and_belongs_to_many :character_classes
  has_and_belongs_to_many :characters
  has_many :items

  include Solr

  def solrJson
    return JSON.generate({
        path: "/proficiencies/" + self.id.to_s,
        id: self.id.to_s,
        title: solrSanitize(self.name),
        description: solrSanitize(self.description),
        category1: "proficiency",
        groups: [ "everyone" ]})
  end
end
