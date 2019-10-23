FROM docker:stable

LABEL "name"="Docker-Build-Push"
LABEL "maintainer"="Zemuldo <danstan.otieno@gmail.com>"
LABEL "version"="1.0"

LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="blue"
LABEL "com.github.actions.name"="Docker Login Build Tag Push"
LABEL "com.github.actions.description"="Login, Build Image, Tag and Push images to any registry"
COPY LICENSE README.md /

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]