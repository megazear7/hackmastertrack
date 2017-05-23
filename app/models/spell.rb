class Spell < ActiveRecord::Base
  has_many :class_spells
  has_many :character_spells

  include Solr

  def solrJson
    return JSON.generate({
        path: "/spells/" + self.id.to_s,
        id: self.id.to_s,
        title: solrSanitize(self.name),
        description: solrSanitize(self.description),
        category1: "spells",
        groups: [ "everyone" ]})
  end
end
