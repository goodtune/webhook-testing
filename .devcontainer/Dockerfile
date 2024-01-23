ARG VARIANT=1
FROM mcr.microsoft.com/vscode/devcontainers/rust:0-${VARIANT}

ENV DEBIAN_FRONTEND=noninteractive

RUN rustup update \
    && rustup component add rls rust-analysis rust-src

USER vscode
