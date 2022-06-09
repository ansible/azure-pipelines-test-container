FROM quay.io/bedrock/ubuntu:focal-20220531

# make sure non-root pip installed binaries are on the user's path
ENV PATH="${PATH}:~/.local/bin"

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    docker.io \
    git \
    openssh-client \
    python3-pip \
    python3.9-venv \
    sudo \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD requirements.txt /tmp/requirements.txt
ADD constraints.txt /tmp/constraints.txt

RUN ln -sf python3.9 /usr/bin/python3
RUN ln -sf python3 /usr/bin/python

RUN pip install \
    -r /tmp/requirements.txt \
    -c /tmp/constraints.txt \
    --disable-pip-version-check \
    --no-cache-dir \
    --no-warn-script-location \
    && \
    rm /tmp/requirements.txt /tmp/constraints.txt
