#!/bin/bash

source support/colors.sh

echo_bold
echo_bold "Stopping SPIRE server and agents in west-2"
echo_bold

kubectl config use-context west-2

kubectl delete -f k8s/20_spire_agent_aws.yaml
kubectl delete -f k8s/10_spire_server_aws.yaml
kubectl delete -f k8s/00_ns_and_sa.yaml

# Wipe out the agent's cached SVID so it will re-attest
minikube -p west-2 ssh 'sudo rm -rf /var/run/spire/agent/*'
minikube -p west-2 ssh 'sudo rm -rf /var/run/spire/global-agent/*'

echo_bold
echo_bold "Stopping SPIRE server and agents in north-1"
echo_bold

kubectl config use-context north-1

kubectl delete -f k8s/40_spire_agent_k8s.yaml
kubectl delete -f k8s/30_spire_server_k8s.yaml
kubectl delete -f k8s/00_ns_and_sa.yaml

echo_bold
echo_bold "Stopping global SPIRE server"

container=$(docker ps | grep spire-server-global | awk '{print $1}' | xargs -n 1 docker kill)

echo_bold "Stopped $container"
echo_bold
