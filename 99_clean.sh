#!/bin/bash

source support/colors.sh

echo_bold "Removing build dir"
rm -rf build

echo_bold "Deleting minikube profile west-2"
minikube delete --profile west-2

echo_bold
echo_bold "Deleting minikube profile north-1"
minikube delete --profile north-1

docker ps | grep spire-server-global > /dev/null

if [ $? != 0 ]; then
        echo_bold
        echo_bold "SPIRE server global tier already stopped"
        echo_bold

        exit
fi

echo_bold
echo_bold "Stopping global SPIRE server"

container=$(docker ps | grep spire-server-global | awk '{print $1}' | xargs -n 1 docker kill)

echo_bold "Stopped $container"
echo_bold
