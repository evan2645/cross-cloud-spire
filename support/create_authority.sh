#!/bin/sh

set -e

./bin/spire-server run 1>/dev/null &

sleep 1

# Stash the bundle so we can use it for subsequent builds
./bin/spire-server bundle show > bootstrap.pem

# Create a workload entry for our downstream SPIRE server in west-1
./bin/spire-server entry create -downstream \
        -selector k8s:ns:spire \
        -selector k8s:sa:spire-server \
        -selector k8s:container-name:spire-server \
        -parentID spiffe://example.org/spire/agent/aws_iid/884177950120/us-west-2/i-0ac1a6bb7a9ea004c \
        -spiffeID spiffe://example.org/aws-west-2/spire-server

# Create a node entry for our k8s cluster in north-1
./bin/spire-server entry create -node \
        -selector k8s_psat:cluster:north-1 \
        -selector k8s_psat:agent_ns:spire \
        -selector k8s_psat:agent_sa:spire-server \
        -spiffeID spiffe://example.org/k8s-cluster/north-1

# Create a workload entry for our downstream SPIRE server in north-1
./bin/spire-server entry create -downstream \
        -selector k8s:ns:spire \
        -selector k8s:sa:spire-server \
        -parentID spiffe://example.org/k8s-cluster/north-1 \
        -spiffeID spiffe://example.org/k8s-cluster/north-1/spire-server

kill %1
