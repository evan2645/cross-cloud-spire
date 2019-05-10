#!/bin/bash

source support/colors.sh

minikube status --profile west-1 > /dev/null
west_1_status=$?
minikube status --profile north-1 > /dev/null
north_1_status=$?

set -e

if [ $west_1_status != "0" ]; then
        echo_bold
        echo_bold "Starting minikube profile \"west-1\""
        echo_bold

        minikube start -p "west-1" --kubernetes-version v1.14.1 \
                       --extra-config=kubelet.authentication-token-webhook=true \
                       --extra-config=kubelet.authorization-mode=Webhook
else
        echo_bold
        echo_bold "Minikube profile \"west-1\" is already started"
        echo_bold
fi

if [ $north_1_status != "0" ]; then
        echo_bold
        echo_bold "Starting minikube profile \"north-1\""
        echo_bold

	minikube start -p "north-1" --kubernetes-version v1.14.1 \
                       --extra-config=apiserver.authorization-mode=RBAC \
                       --extra-config=apiserver.service-account-signing-key-file=/var/lib/minikube/certs/sa.key \
                       --extra-config=apiserver.service-account-key-file=/var/lib/minikube/certs/sa.pub \
                       --extra-config=apiserver.service-account-issuer=api \
                       --extra-config=apiserver.service-account-api-audiences=api,spire-server \
                       --extra-config=kubelet.authentication-token-webhook=true \
                       --extra-config=kubelet.authorization-mode=Webhook
else
        echo_bold
        echo_bold "Minikube profile \"north-1\" is already started"
        echo_bold
fi
