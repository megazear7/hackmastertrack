namespace :transfer do

  def app_name id
    { "prod"  => "hackmastertrack",
      "test"  => "hackmastertrack-test"
    } [id]
  end

  def db_name location
    # "prod" SHOULD NEVER EVER EVER BE USED IN THIS CONTEXT
    { "test"  => "HEROKU_POSTGRESQL_GOLD_URL",
    } [location]
  end

  def remote_url remote
    # "prod" SHOULD NEVER EVER EVER BE USED IN THIS CONTEXT
    { "test"  => "git@heroku.com:hackmastertrack-test.git",
    } [remote]
  end

  def call str
    puts green(str)
    system str
  end

  def to_remote src, dest, base_branch, final_branch
    puts "Your must #{red('commit')} or stashed your local changes and " +
         "we will be executing a #{red('forceful push')} to #{dest}..."
    Bundler.with_clean_env { # heroku commands must be ran in a bundler block
      call "heroku pgbackups:capture -a #{app_name(src)} --expire"
      call "git checkout #{base_branch}"
      call "git push #{remote_url(dest)} #{base_branch}:master -f"
      call "heroku pg:reset #{db_name(dest)} -a #{app_name(dest)} " +
           "--confirm #{app_name(dest)}"
      call "heroku pgbackups:restore #{db_name(dest)} `heroku pgbackups:url " +
           "-a #{app_name(src)}` -a #{app_name(dest)} " +
           "--confirm #{app_name(dest)}"
      call "git checkout #{final_branch}"
      call "git push #{remote_url(dest)} #{final_branch}:master"
      call "heroku run rake db:migrate -a #{app_name(dest)}"
    }
    puts "Transfer complete!"
  end

  def to_local src, dest, base_branch, final_branch
    puts "You must #{red('commit')} or stash your local changes " + 
         "you must #{red('stop your server')}..."
    Bundler.with_clean_env { # heroku commands must be ran in a bundler block
      call "heroku pgbackups:capture -a #{app_name(src)} --expire"
      call "curl -o latest.dump `heroku pgbackups:url -a #{app_name(src)}`"
      call "git checkout #{base_branch}"
      call "rake db:reset"
      call "pg_restore --verbose --clean --no-acl --no-owner -d " +
           "qb_development latest.dump"
      call "git checkout #{final_branch}"
      call "rake db:migrate"
      call "rake db:migrate RAILS_ENV=test"
    }
    puts "Transfer complete, go ahead and restart your server!"
  end


  def transfer src, dest, base_branch
    puts "Transfering #{blue(src)} database to #{blue(dest)}:"
    final_branch = `git rev-parse --abbrev-ref HEAD`.chomp
    base_branch  = ENV['base']  if ENV['base']
    final_branch = ENV['final'] if ENV['final']
    case dest
    when "local"
      to_local  src, dest, base_branch, final_branch
    when "test", "test2"
      to_remote src, dest, base_branch, final_branch
    end
  end

  namespace :prod do
    task local: :environment do
      transfer "prod", "local", "master"
    end
    task test: :environment do
      transfer "prod", "test", "master"
    end
  end

  namespace :test do
    task local: :environment do
      transfer "test", "local", "master"
    end
  end
end
