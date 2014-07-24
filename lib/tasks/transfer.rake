namespace :transfer do

  namespace :prod do
    task local: :environment do

      puts "Have you stopped your server and commited or stashed all local changes?"
      answer = STDIN.gets.chomp

      if answer.downcase == "y" or answer.downcase == "yes"
        puts   "heroku pgbackups:capture -a hackmastertrack --expire"
        system "heroku pgbackups:capture -a hackmastertrack --expire"

        puts   "curl -o latest.dump `heroku pgbackups:url -a hackmastertrack`"
        system "curl -o latest.dump `heroku pgbackups:url -a hackmastertrack`"

        puts   "rake db:reset"
        system "rake db:reset"

        puts   "pg_restore --verbose --clean --no-acl --no-owner -d hmt_development latest.dump"
        system "pg_restore --verbose --clean --no-acl --no-owner -d hmt_development latest.dump"

        puts   "rake db:migrate"
        system "rake db:migrate"
      end
    end
  end

end
