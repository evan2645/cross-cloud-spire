#!/bin/bash

source support/colors.sh

docker ps | grep spire-server-global > /dev/null

if [ $? == 0 ]; then
        echo_bold
        echo_bold "SPIRE server global tier already started"
        echo_bold

        exit
fi

set -e

echo_bold
echo_bold "Starting SPIRE server global tier as host-based container"

CONTAINER_ID=$(docker run -d -p 8081:8081 spire-server-global)

echo_bold "Started container $CONTAINER_ID"
echo_bold
