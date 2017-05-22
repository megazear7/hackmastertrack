namespace :solr do
  def call str
    puts green(str)
    system str
  end

  task index: :environment do
    Character.all.each do |character|
      call "curl 'http://ec2-52-33-82-145.us-west-2.compute.amazonaws.com:8983/solr/hacksolr/update?commit=true&wt=json' -H 'Content-Type: text/json' --data-binary '[#{character.solr}]'"
    end
  end
end
