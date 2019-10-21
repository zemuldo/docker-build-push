# docker-build-push

GitHub action to build, tag and push images to Registry.
You can use this image with currently `docker.io` or any of Google Cloud Registries like `gcr.io`.

Configuration takes two inputs and environmental variable configurations of  your repository.

Below are some examples. This action will be published when fully polished.

## Examples

Here are examples of workflows that use this action on only push to master.

### Push to Google Cloud Registry eg gcr.io

```yml
name: Build and Push
on: 
  push:
      branches:    
          - master
jobs:
  build_publish_gcr:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1

    - name: Build and Push
      uses: zemuldo/docker-build-push@master
      env:
        GCLOUD_PROJECT_ID: ${{ secrets.GCLOUD_PROJECT_ID }}
        GCLOUD_AUTH: ${{ secrets.GCLOUD_AUTH }}
        REGISTRY_URL: "gcr.io"
      with:
       image_name: "my-image"
       image_tag: "latest"
```

### Pus to docker hub

```yml
name: Publish GRC
on: 
  push:
      branches:    
          - master
          - develop
jobs:

  build_publish_docker_hub:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1

    - name: Build and Push
      uses: zemuldo/docker-build-push@master
      env:
        DOCKER_USERNAME: "zemuldo"
        DOCKER_NAMESPACE: "zemuldo"
        DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
        REGISTRY_URL: "docker.io"
      with:
       image_name: "my-image"
       image_tag: "latest"
```
