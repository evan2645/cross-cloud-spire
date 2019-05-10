#!/bin/bash

source support/colors.sh

echo_bold
echo_bold "Halting minikube in west-1"
echo_bold

minikube stop --profile west-1

echo_bold
echo_bold "Halting minikube in north-1"
echo_bold

minikube stop --profile north-1

echo_bold
