#!/bin/sh

# mapping of var from user input or default value

echo "$2" | base64 -d > "$HOME"/gcloud-service-key.json


IMAGE_NAME=${$3:-$REPOSITORY} ## use github repository name as docker image name unless specified
IMAGE_TAG=${$4:-$GIT_TAG} ## use git ref value as docker image tag unless specified

echo "$3"
echo "$4"

sh -c "docker build -t $3 ${*:-.}" 
