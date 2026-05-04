#!/bin/sh
set -eu

echo "Initializing ${MYSQL_DATABASE} from /docker-schema/schema.sql"
mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" "${MYSQL_DATABASE}" < /docker-schema/schema.sql

