FROM nvidia/cuda:10.2-base-ubuntu18.04

LABEL maintainer="dockerfile@codingcoffee.me"

ARG VERSION="v7.6"

RUN set -ex \
  && apt update \
  && apt upgrade -y \
  && apt update \
  && apt install -y \
    bzip2 \
    software-properties-common \
    tzdata \
    wget \
  && add-apt-repository -y ppa:graphics-drivers \
  && apt install -y \
    nvidia-opencl-dev \
  && useradd --system folding \
  && mkdir -p /opt/fahclient \
  && wget https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/${VERSION}/latest.tar.bz2 -O /tmp/fahclient.tar.bz2 \
  && tar -xjf /tmp/fahclient.tar.bz2 -C /opt/fahclient --strip-components=1 \
  && wget https://apps.foldingathome.org/GPUs.txt -O /opt/fahclient/GPUs.txt \
  && chown -R folding:folding /opt/fahclient \
  && rm -rf /tmp/fahclient.tar.bz2 \
  && apt remove -y software-properties-common \
  && apt autoremove -y \
  && apt clean autoclean \
  && rm -rf /var/lib/apt/lists/*

COPY --chown=folding:folding entrypoint.sh /opt/fahclient

USER folding
WORKDIR /opt/fahclient

ENV USER "Anonymous"
ENV TEAM "0"
ENV ENABLE_GPU "false"
ENV ENABLE_SMP "true"
ENV POWER "full"

EXPOSE 7396

ENTRYPOINT ["/opt/fahclient/entrypoint.sh"]

