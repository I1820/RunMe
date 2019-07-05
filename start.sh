#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : start.sh
#
# [] Creation Date : 03-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

# dependencies

up-network() {
        docker network create i1820
}

up-loraserver() {
        docker-compose -f loraserver.io/docker-compose.yml up -d
}

up-mongodb() {
        docker-compose -f mongodb/docker-compose.yml up -d
}

up-vernemq() {
        docker-compose -f vernemq/docker-compose.yml up -d
}

# monitoring

up-prometheus() {
        docker-compose -f prometheus/docker-compose.yml $@
}

up-portainer() {
        docker-compose -f portainer/docker-compose.yml $@
}

up-grafana() {
        docker-compose -f grafana/docker-compose.yml $@
}

# utils

up-uprojects() {
        # el (project) containers
        docker ps -a --filter name="el_*" --format "{{.ID}}" | xargs docker start
        # rd (redis) containers
        docker ps -a --filter name="rd_*" --format "{{.ID}}" | xargs docker start
}

declare -A groups
groups=(
        ["dependencies"]="network mongodb vernemq loraserver"
        ["monitoring"]="portainer prometheus grafana"
        ["utils"]="uprojects"
)

usage() {
        echo "usage: start.sh <group> <up/teardown>"
        echo
        echo "each group contains the specific service of I1820 platform"
        echo "this script will help you to run the signle instance versio of I1820 platfrom"
        echo "by configuring the script in your way you can run I1820 in different environments"
        echo

        echo "groups:"

        echo "1) dependencies"
        echo "network:    I1820 private network"
        echo "mongodb:    The most popular database for modern apps"
        echo "vernemq:    A distributed MQTT message broker based on Erlang/OTP"
        echo "loraserver: LoRa Server is an open-source LoRaWAN network-server"
        echo

        echo "2) monitoring"
        echo

        echo "3) utils"
        echo "uprojects: Platfrom user's project/redis dockers"
        echo
}

if [[ $# -ne 2 ]]; then
        usage
        exit
fi

group=$1
cmd=$2

if [ $cmd != "up" ] && [ $cmd != "teardown" ]; then
        usage
        exit
fi

services=${groups[$group]}

for service in $services; do
        echo "> $service"

        start=$(date +'%s')

        "$cmd-$service"

        took=$(( $(date +'%s') - $start ))
        printf "Done. Took %ds.\n" $took

        echo ">"
done
