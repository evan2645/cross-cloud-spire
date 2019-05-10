#!/bin/bash

source support/colors.sh

echo_bold "Removing build dir"
rm -rf build

echo_bold "Deleting minikube profile west-1"
minikube delete --profile west-1

echo_bold
echo_bold "Deleting minikube profile north-1"
minikube delete --profile north-1
