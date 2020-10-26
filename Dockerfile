FROM ubuntu:20.04

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    docker.io \
    git \
    openssh-client \
    python-is-python3 \
    python3 \
    python3-pip \
    python3-venv \
    sudo \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s pip3 /usr/bin/pip

ADD requirements.txt /tmp/requirements.txt

RUN pip install \
    -r /tmp/requirements.txt \
    --user \
    --disable-pip-version-check \
    --no-cache-dir \
    --no-warn-script-location \
    && \
    rm /tmp/requirements.txt
