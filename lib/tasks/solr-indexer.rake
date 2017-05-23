namespace :solr do
  def call str
    puts green(str)
    system str
  end

  def index jsonArrStr
    call "curl 'http://ec2-52-33-82-145.us-west-2.compute.amazonaws.com:8983/solr/hacksolr/update?commit=true&wt=json' -H 'Content-Type: text/json' --data-binary '#{jsonArrStr}'"
  end

  def solrJsonAppender jsonArrStr, jsonObjStr
    jsonObjStr = "," + jsonObjStr if jsonArrStr != "[]"
    jsonArrStr.insert(-2, jsonObjStr)
  end

  task index: :environment do
    records = Character.all + Item.all
    jsonArrStr = "[]"

    records.each do |character|
      jsonArrStr = solrJsonAppender(jsonArrStr, character.solrJson)
    end

    jsonArrStr.gsub!("'", "'\"'\"'")

    index jsonArrStr 
  end
end
