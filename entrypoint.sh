#!/bin/sh

# Put GCP service account key from base64 to json on a file.
echo "$GCLOUD_AUTH" | base64 -d > "$HOME"/gcloud-service-key.json

DOCKER_REGISTRY_URL="$REGISTRY_URL"
DOCKER_IMAGE_NAME="$1"
DOCKER_IMAGE_TAG="$2"

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

# Login Docker with GCP Service Account key
# Guide here https://cloud.google.com/container-registry/docs/advanced-authentication#gcloud_docker
sh -c "cat "$HOME"/gcloud-service-key.json | docker login -u _json_key --password-stdin https://$REGISTRY"

# Build Docker Image Locally with provided Image Name
sh -c "docker build -t $IMAGE_NAME ." ## pass in the build command from user input, otherwise build in default mode

# Set the registy URL grc.io/image_name or docker.io/image_name
REGISTRY_IMAGE="$REGISTRY/$IMAGE_NAME"

# Tag image with speciefied tag or latest
sh -c "docker tag $IMAGE_NAME $REGISTRY_IMAGE:$DOCKER_IMAGE_TAG"

# Push image to registry
sh -c "docker push $REGISTRY_IMAGE:$IMAGE_TAG"