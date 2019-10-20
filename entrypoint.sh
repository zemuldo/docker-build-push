#!/bin/sh

# mapping of var from user input or default value

echo "$2" | base64 -d > "$HOME"/gcloud-service-key.json

## if needed to filter the branch
if [ -n "${BRANCH_FILTER+set}" ] && [ "$ref_value" != "$BRANCH_FILTER" ]
then
  exit 78 ## exit neutral
fi

GIT_TAG=${ref_value//\//-} ## replace `/` with `-` in ref for docker tag requirement (master or 2019-03-13)
if [ -n "${DOCKER_TAG_APPEND+set}" ] ## right append to tag if specified
then
    GIT_TAG=${GIT_TAG}_${DOCKER_TAG_APPEND}
fi

REGISTRY=${$3:-"grc.io"} ## use default Docker Hub as registry unless specified
IMAGE_NAME=${$3:-$REPOSITORY} ## use github repository name as docker image name unless specified
IMAGE_TAG=${$4:-$GIT_TAG} ## use git ref value as docker image tag unless specified

echo IMAGE_NAME
echo IMAGE_TAG

# sh -c "docker build -t $IMAGE_NAME ${*:-.}" 
