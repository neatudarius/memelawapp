# unde from_sql.txt va fi  copy-paste la ceee ce se afiseaza in consola sql in urma comenzii
# SELECT * FROM memes;
# mai stergi din liniile proaste
#cat from_sql.txt | awk -F"|" '{print "INSERT INTO memes VALUES(NULL,\"" $2 "\",\"" $3 "\",0,\"" $5 "\",\"" $6 "\",0,0,0,NULL,NULL);"}' > to_append_to_MemesApp.sql.txt
rm -rf sqlite3 db/development.sqlite3
rake db:migrate
sqlite3 db/development.sqlite3 < MemesApp.sql
rake db:migrate