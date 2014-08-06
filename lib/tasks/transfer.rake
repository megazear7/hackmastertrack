namespace :transfer do

  namespace :prod do
    task local: :environment do

      puts "Have you stopped your server and commited or stashed all local changes?"
      answer = STDIN.gets.chomp

      if answer.downcase == "y" or answer.downcase == "yes"
        run "heroku pgbackups:capture -a hackmastertrack --expire"
        run "curl -o latest.dump `heroku pgbackups:url -a hackmastertrack`"
        run "rake db:reset"
        run "pg_restore --verbose --clean --no-acl --no-owner -d hmt_development latest.dump"
        run "rake db:migrate"
      end
    end
  end

  def run str
    puts str
    system str
  end

end
