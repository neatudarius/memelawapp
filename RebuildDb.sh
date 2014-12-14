rm -rf sqlite3 db/development.sqlite3
rake db:migrate
sqlite3 db/development.sqlite3 < MemesApp.sql
rake db:migrate
git add db/development.sqlite3 UpdateDb.sh MemesApp.sql