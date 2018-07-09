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
	local name=""

        docker-compose -f loraserver.io/docker-compose.yml $@
}

start-mongodb() {
	local name=""

        docker-compose -f mongodb/docker-compose.yml $@
}

start-pm() {
	local name=""

        docker-compose -f pm/docker-compose.yml $@
}

start-dm() {
	local name=""

        docker-compose -f dm/docker-compose.yml $@
}

start-uplink() {
	local name=""

        docker-compose -f uplink/docker-compose.yml $@
}

start-downlink() {
	local name=""

        docker-compose -f downlink/docker-compose.yml $@
}

start-prometheus() {
	local name=""

        docker-compose -f prometheus/docker-compose.yml $@
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
        echo "prometheus        docker-compose prom/prometheus"
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
        usage
fi
