#!/bin/bash
set -e

if [ "$1" = 'redis-server' ]; then
	cat /usr/local/etc/redis_template.conf | envsubst > /usr/local/etc/redis.conf
        chown -R redis .
        exec gosu redis "$@"
fi

exec "$@"

