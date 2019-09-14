#!/bin/sh

echo "$DB_HOST:$DB_PORT IS LIVE!"

### ---- Do NOT edit below this line ---- ###

# Add the symlinks for logs to allow NGINX & set Laravel to log to file instead of to stdout
if [ -n "$LOG_FILES" ]
then
	if [ "$LOG_FILES" = "true" ]
	then
		echo "---------------"
		echo "LOG_FILES set to true. Writing logs to disk......"
		rm /var/log/nginx/access.log
		rm /var/log/nginx/error.log
 		ln -sf $NGINX_DOCUMENT_ROOT/storage/logs/access.log /var/log/nginx/access.log
		ln -sf $NGINX_DOCUMENT_ROOT/storage/logs/error.log /var/log/nginx/error.log
		echo "YOUR LOGS CAN BE FOUND IN $NGINX_DOCUMENT_ROOT/storage/logs/ WITHIN THE CONTAINER"
		echo "---------------"
		export APP_LOG="single" 
	fi
fi

# Supervisor Default
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
