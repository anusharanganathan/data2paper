\set data2paper_password `echo "'$DATA2PAPER_PASSWORD'"`
CREATE USER data2paper WITH SUPERUSER CREATEROLE LOGIN PASSWORD :data2paper_password;
