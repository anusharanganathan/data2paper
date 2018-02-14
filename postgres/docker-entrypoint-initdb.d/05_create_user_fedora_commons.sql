\set fedora_password `echo "'$FEDORA_COMMONS_PASSWORD'"`
CREATE USER fedora_commons WITH SUPERUSER CREATEROLE LOGIN PASSWORD :fedora_password;
