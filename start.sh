#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : start.sh
#
# [] Creation Date : 03-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================
start-loraserver() {
        if [[ $ENV = "prod" ]]; then
                docker-compose -f loraserver.io/docker-compose.yml -p loraserver-prod -f loraserver.io/docker-compose.prod.yml $@
        elif [[ $ENV = "dev" ]]; then
                docker-compose -f loraserver.io/docker-compose.yml -p loraserver-dev -f loraserver.io/docker-compose.dev.yml $@
        else
                docker-compose -f loraserver.io/docker-compose.yml -p loraserver-home -f loraserver.io/docker-compose.home.yml $@
        fi
}

start-mongodb() {
        docker-compose -f mongodb/docker-compose.yml $@
}

start-pm() {
        docker-compose -f pm/docker-compose.yml $@
}

start-dm() {
        docker-compose -f dm/docker-compose.yml $@
}

start-uplink() {
        docker-compose -f uplink/docker-compose.yml $@
}

start-downlink() {
        docker-compose -f downlink/docker-compose.yml $@
}

start-uprojects() {
        # el (project) containers
        docker ps -a --filter name="el_*" --format "{{.ID}}" | xargs docker start
        # rd (redis) containers
        docker ps -a --filter name="rd_*" --format "{{.ID}}" | xargs docker start
}

start-cleanup() {
        for name in $(curl -s "127.0.0.1:8080/api/project" | jq -r '.[].name'); do
	        echo $name
	        curl -X DELETE -o /dev/null -w "%{http_code}" -s "127.0.0.1:8080/api/project/$name"
        done
}

usage() {
        echo "usage: start.sh <service> [args]"
        echo "services:"

        echo "mongodb           docker-compose mongodb"
        echo "loraserver        docker-compose brocaar/loraserver"
        echo
        echo "dm        docker-compose aiotrc/dm"
        echo "pm        docker-compose aiotrc/pm"
        echo "uplink    docker-compose aiotrc/uplink"
        echo "downlink  docker-compose aiotrc/downlink"
        echo
        echo "uprojects platfrom users project/redis dockers"
        echo "cleanup   cleans the database up"
}

if [[ $# -eq 0 ]]; then
        usage
        exit
fi

cmd=$1
shift
if [ $(type -t start-$cmd)"" = 'function' ]; then
        echo "Start $cmd"
        echo
        start=$(date +'%s')

        "start-$cmd" "$@"

        echo
        took=$(( $(date +'%s') - $start ))
        printf "Done. Took %ds.\n" $took
else
        echo "Unknown service: $cmd"
fi
