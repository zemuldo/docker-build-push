#!/bin/sh

# mapping of var from user input or default value

echo "$2" | base64 -d > "$HOME"/gcloud-service-key.json

DOCKER_REGISTRY_URL="$1"
DOCKER_IMAGE_NAME="$3"
DOCKER_IMAGE_TAG="$4"

USERNAME=${GITHUB_REPOSITORY%%/*}
REPOSITORY=${GITHUB_REPOSITORY#*/}

ref_tmp=${GITHUB_REF#*/} ## throw away the first part of the ref (GITHUB_REF=refs/heads/master or refs/tags/2019/03/13)
ref_type=${ref_tmp%%/*} ## extract the second element of the ref (heads or tags)
ref_value=${ref_tmp#*/} ## extract the third+ elements of the ref (master or 2019/03/13)

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

REGISTRY=${DOCKER_REGISTRY_URL} ## use default Docker Hub as registry unless specified
NAMESPACE=${DOCKER_NAMESPACE:-$USERNAME} ## use github username as docker namespace unless specified
IMAGE_NAME=${DOCKER_IMAGE_NAME:-$REPOSITORY} ## use github repository name as docker image name unless specified
IMAGE_TAG=${DOCKER_IMAGE_TAG:-$GIT_TAG} ## use git ref value as docker image tag unless specified

sh -c "cat "$HOME"/gcloud-service-key.json | docker login -u _json_key --password-stdin https://$REGISTRY"

## build the image locally
sh -c "docker build -t $IMAGE_NAME ." ## pass in the build command from user input, otherwise build in default mode

REGISTRY_IMAGE="$REGISTRY/$IMAGE_NAME"

sh -c "docker tag $IMAGE_NAME $REGISTRY_IMAGE:$DOCKER_IMAGE_TAG"

sh -c "docker push $REGISTRY_IMAGE:$IMAGE_TAG"