#!/bin/bash
set -eo pipefail
shopt -s nullglob

# Translate Variables and Files to Environment
file_env() {
	local var="$1"
	echo -n "Setting $var ... "
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

# Check Variables Exist & Translate from file
# EXAMPLE
# file_env 'DB_PORT'
# if [ -z "$DB_PORT" ]; 
# then
# 	echo >&2 'ERROR'
# 	echo >&2 'Lan Manager App is uninitialized because DB_PORT is not specified '
# 	echo >&2 'You need to specify DB_PORT'
# 	exit 1
# else
# 	echo 'OK'
# fi

# Database Wait check
echo "---------------"
echo "WAITING FOR $DB_HOST:$DB_PORT..."
/run/wait-for.sh $DB_HOST:$DB_PORT --timeout=30 --strict -- /run/start-supervisord.sh
