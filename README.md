# "Cross-Cloud" SPIRE Example Using Minikube

**This example is under active development**

SPIRE can help solve cross-cluster and cross-cloud identity/authentication challenges, but there isn't a ton of guidance on how to do so. This example sets up two minikube instances and a "global" container running on the host machine in order to show one possible configuration of SPIRE that can support multiple clouds and multiple clusters.

Originally prepared for KubeCon EU 2019

## Requirements

This example was developed, tested, and presented from MacOS. It might work on Linux too with little or no changes, but I have not tried.

* Docker
* VirtualBox
* Minikube
* Make

An instance of SPIRE server will be started on the host machine and by default it binds to port 8081. If anything else is listening on port 8081, it will fail to start.

## Starting the example

This example contains some dockerfiles, some kubernetes yaml, and a bunch of shell scripts. They are tied together by a Makefile so turning things up and down is simple. To get up and running, clone this repo and try out the following commands:

* `make start`: Gets everything up and running. Will start and configure minikube, build docker images, and deploy SPIRE servers and agents. Safe to run again and again.
* `make stop`: Tears down SPIRE server and agent deployments and related configuration. Does not stop minikube, though.
* `make halt`: Stops minikube
* `make clean`: Deletes minikube clusters and fully resets this example
