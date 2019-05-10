#!/bin/bash

source support/colors.sh

set -e

echo_bold
echo_bold "Extracting kubeconfig for SPIRE node attestor configuration"
echo_bold

mkdir -p build

kubectl config view --flatten > build/kubeconfig.yml

echo_bold
echo_bold "Building docker image for global SPIRE tier"
echo_bold

docker build --no-cache -f Dockerfile.server-global -t spire-server-global .

echo_bold
echo_bold "Building docker image for regional SPIRE tier"
echo_bold

docker build --no-cache -f Dockerfile.server-regional -t spire-server-regional .

echo_bold
echo_bold "Building docker image for SPIRE agent"
echo_bold

docker build --no-cache -f Dockerfile.agent -t spire-agent .

echo_bold
echo_bold "Sending regional images to west-1"
echo_bold

docker save -o build/spire-server-regional.tar spire-server-regional
docker save -o build/spire-agent.tar spire-agent

eval $(minikube docker-env --profile west-1)
docker load -i build/spire-server-regional.tar
docker load -i build/spire-agent.tar

echo_bold
echo_bold "Sending regional image to north-1"
echo_bold

eval $(minikube docker-env --profile north-1)
docker load -i build/spire-server-regional.tar
docker load -i build/spire-agent.tar
