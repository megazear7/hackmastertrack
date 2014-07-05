rake db:migrate
heroku pgbackups:capture -a hackmastertrack --expire
curl -o latest.dump `heroku pgbackups:url -a hackmastertrack`
rake db:reset
pg_restore --verbose --clean --no-acl --no-owner -d hmt_development latest.dump
rake db:migrate
