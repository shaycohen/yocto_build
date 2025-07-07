FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
      python3 \
      python3-venv \
      python3-pip \
      gawk \
      wget \
      git \
      diffstat \
      unzip \
      texinfo \
      gcc-multilib \
      build-essential \
      chrpath \
      socat \
      cpio \
      iputils-ping \
      locales \
      curl \
      xterm && \
    rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN useradd -m -s /bin/bash yocto

USER yocto
WORKDIR /home/yocto

# Install repo
RUN mkdir -p ~/bin && \
    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo && \
    chmod a+x ~/bin/repo

ENV PATH="/home/yocto/bin:${PATH}"
ENV SHELL=/bin/bash

RUN git config --global user.name "Build User"
RUN git config --global user.email "build@dev.sh"


COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
