cat from_sql.txt | awk -F"|" '{print "INSERT INTO memes VALUES(NULL,\"" $2 "\",\"" $3 "\",0,\"" $5 "\",\"" $6 "\",0,0,0,NULL,NULL);"}' > to_append_to_MemesApp.sql.txt

