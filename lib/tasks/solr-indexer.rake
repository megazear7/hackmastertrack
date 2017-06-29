namespace :solr do
  def call str
    puts green(str)
    system str
  end

  def index jsonArrStr, url
    jsonArrStr.gsub!("'", "'\"'\"'")
    call "curl '#{url}/update?commit=true&wt=json' -H 'Content-Type: text/json' --data-binary '#{jsonArrStr}'"
  end

  def solrJsonAppender jsonArrStr, jsonObjStr
    jsonObjStr = "," + jsonObjStr if jsonArrStr != "[]"
    jsonArrStr.insert(-2, jsonObjStr)
  end

  def indexer url
    records = Character.all + Item.all + Talent.all + Spell.all + Talent.all + CharacterClass.all + Race.all + Proficiency.all
    jsonArrStr = "[]"
    count = 0

    records.each do |character|
      jsonArrStr = solrJsonAppender(jsonArrStr, character.solrJson)
      count += 1

      if count == 200
        index jsonArrStr 
        jsonArrStr = "[]"
      end
    end
    
    index jsonArrStr, url
  end

  task index: :environment do
    task local: :environment do
        indexer("http://localhost:8983/solr/hacksolr/update?commit=true&wt=json")
    end

    task prod: :environment do
        indexer("http://ec2-52-33-82-145.us-west-2.compute.amazonaws.com:8983/solr/hacksolr/update?commit=true&wt=json")
    end
  end
end
