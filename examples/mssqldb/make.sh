#!/bin/bash
MYPATH="$(cd "$(dirname "$0")"; pwd)"
cd "$MYPATH"
. ./env.shlib
SQL=$$.sql
bash mssqldb.temp "$DBNAME" "$DBSA" "$DBPWD" > "$SQL"
sqlcmd -U "$SA" -P "$SAPWD" < "$SQL"
