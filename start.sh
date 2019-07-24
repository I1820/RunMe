#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : start.sh
#
# [] Creation Date : 03-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

# groups

declare -A groups
groups=(
        ["dependencies"]="mongodb vernemq loraserver"
        ["monitoring"]="portainer prometheus grafana"
)

handle_groups() {
        group=$1
        cmd=$2

        if [ $cmd != "up" ] && [ $cmd != "teardown" ]; then
                return
        fi

        services=${groups[$group]}
        if [ ${#services} -eq 0 ]; then
                echo "$group is not available"
                return
        fi


        "before-$group-$cmd"
        for service in $services; do
                echo "> $service"

                start=$(date +'%s')

                "$cmd-$service"

                took=$(( $(date +'%s') - $start ))
                printf "Done. Took %ds.\n" $took

                echo ">"
        done
        "after-$group-$cmd"
}

## dependencies

before-dependencies-up() {
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

after-dependencies-up() {
        echo "dependencies are up"
}

before-dependencies-teardown() {
        echo "dependencies are going down"
}

teardown-loraserver() {
        docker-compose -f loraserver.io/docker-compose.yml down
}

teardown-mongodb() {
        docker-compose -f mongodb/docker-compose.yml down
}

teardown-vernemq() {
        docker-compose -f vernemq/docker-compose.yml down
}

after-dependencies-teardown() {
        docker network rm i1820
}

## monitoring

up-prometheus() {
        docker-compose -f prometheus/docker-compose.yml up -d
}

up-portainer() {
        docker-compose -f portainer/docker-compose.yml up -d
}

up-grafana() {
        docker-compose -f grafana/docker-compose.yml up -d
}

# utils

handle_utils() {
        cmd=$1

        if [ "$(type -t $cmd)" == 'function' ]; then
                $cmd
        else
                echo "$cmd is not a util command"
                return
        fi
}

uprojects() {
        echo "el (project) containers"
        docker ps -a --filter name="el_*" --format "{{.ID}}" | xargs docker start
        echo "rd (redis) containers"
        docker ps -a --filter name="rd_*" --format "{{.ID}}" | xargs docker start
}

usage() {
        echo "usage: start.sh <group> <up/teardown>"
        echo
        echo "each group contains the specific service of I1820 platform"
        echo "this script will help you to run the signle instance versio of I1820 platfrom"
        echo "by configuring the script in your way you can run I1820 in different environments"
        echo

        echo "groups:"

        echo "1) dependencies"
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

if [ $group == "utils" ]; then
        handle_utils $cmd
else
        handle_group $group $cmd
fi
