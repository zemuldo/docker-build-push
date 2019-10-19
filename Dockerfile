FROM docker:stable

RUN apk add --update make ca-certificates openssl python

RUN update-ca-certificates

RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz

RUN tar zxvf google-cloud-sdk.tar.gz && ./google-cloud-sdk/install.sh --usage-reporting=false --path-update=true

RUN google-cloud-sdk/bin/gcloud --quiet components update

LABEL "name"="GRC-Docker-Build-Push"
LABEL "maintainer"="Zemuldo <danstan.otieno@gmail.com>"
LABEL "version"="1.0.0"

LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"
LABEL "com.github.actions.name"="Build and Push GRC"
LABEL "com.github.actions.description"="Install Google Cloud SDK, Login, Build Image, Tag and Push"
COPY LICENSE README.md /

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]