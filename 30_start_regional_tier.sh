#!/bin/bash

source support/colors.sh

set -e

# Normally this can be done with kubectl create configmap --from-file,
# however that command fails if the configmap already exists and fails
# to update it if the file has changed. Instead, directly run apply to
# get the benefits of config update when this script is run.
function generate_configmap () {
        CONFIGMAP_NAME=$1
        CONFIGMAP_FILE_NAME=$2
        PATH_TO_CONFIG=$3

        config_data=$(cat $PATH_TO_CONFIG | sed "s/^/    /")

        cat <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: $CONFIGMAP_NAME
  namespace: spire
data:
  $CONFIGMAP_FILE_NAME: |
$config_data
EOF
}

echo_bold
echo_bold "Deploying SPIRE server and agents in west-1 using AWS-based node attestation"
echo_bold

kubectl config use-context west-1

kubectl apply -f k8s/00_ns_and_sa.yaml

server_config=$(generate_configmap server-config server.conf conf/server/regional.conf)
agent_config=$(generate_configmap agent-config agent.conf conf/agent/regional_aws.conf)
global_agent_config=$(generate_configmap global-agent-config agent.conf conf/agent/global_aws.conf)
echo "$server_config" | kubectl apply -f -
echo "$agent_config" | kubectl apply -f -
echo "$global_agent_config" | kubectl apply -f -


kubectl apply -f k8s/10_spire_server_aws.yaml
kubectl apply -f k8s/20_spire_agent_aws.yaml

echo_bold
echo_bold "Deploying SPIRE server and agents in north-1 using K8s-based node attestation"
echo_bold

kubectl config use-context north-1

kubectl apply -f k8s/00_ns_and_sa.yaml

server_config=$(generate_configmap server-config server.conf conf/server/regional.conf)
agent_config=$(generate_configmap agent-config agent.conf conf/agent/regional_k8s.conf)
global_agent_config=$(generate_configmap global-agent-config agent.conf conf/agent/global_k8s.conf)
echo "$server_config" | kubectl apply -f -
echo "$agent_config" | kubectl apply -f -
echo "$global_agent_config" | kubectl apply -f -

kubectl apply -f k8s/30_spire_server_k8s.yaml
kubectl apply -f k8s/40_spire_agent_k8s.yaml
