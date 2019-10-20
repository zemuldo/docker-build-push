FROM docker:stable

LABEL "name"="GCRT-Docker-Build-Push"
LABEL "maintainer"="Zemuldo <danstan.otieno@gmail.com>"
LABEL "version"="1.0.0"

LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"
LABEL "com.github.actions.name"="Build and Push GRC"
LABEL "com.github.actions.description"="Install Google Cloud SDK, Login, Build Image, Tag and Push"
COPY LICENSE README.md /

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]