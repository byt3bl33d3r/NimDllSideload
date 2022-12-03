FROM mcr.microsoft.com/devcontainers/python:3.11

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends build-essential mingw-w64 binutils

USER vscode
ENV CHOOSENIM_NO_ANALYTICS 1
ENV PATH $HOME/.nimble/bin:$PATH
RUN echo 'export PATH="$HOME/.nimble/bin:$PATH"' >> ~/.profile