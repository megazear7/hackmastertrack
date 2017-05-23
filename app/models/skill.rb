class Skill < ActiveRecord::Base
  has_and_belongs_to_many :characters
  has_and_belongs_to_many :races_skills
  has_many :races, through: :races_skills

  include Solr

  def solrJson
    return JSON.generate({
        path: "/skills/" + self.id.to_s,
        id: self.id.to_s,
        title: solrSanitize(self.name),
        description: solrSanitize(self.description),
        category1: "skills",
        groups: [ "everyone" ]})
  end
end
