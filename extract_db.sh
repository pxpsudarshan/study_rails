#!/bin/sh

#penssl aes-256-cbc -pbkdf2 -iter 310000 -d -base64 -in niho_backup.tar.enc -out niho_backup.tar
openssl aes-256-cbc -d -base64 -in niho_backup.tar.enc -out niho_backup.tar
tar -xvf niho_backup.tar
gunzip ./niho_backup/databases/PostgreSQL.sql.gz
