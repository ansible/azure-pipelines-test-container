FROM quay.io/bedrock/alpine:3.19.1

# make sure non-root pip installed binaries are on the user's path
ENV PATH="${PATH}:~/.local/bin"

RUN apk add \
    curl \
    docker-cli \
    git \
    openssh-client \
    py3-pip \
    python3 \
    sudo \
    --no-cache

ADD requirements.txt /tmp/requirements.txt
ADD constraints.txt /tmp/constraints.txt

# allow pip installs without requiring additional options
RUN rm /usr/lib/python*/EXTERNALLY-MANAGED

ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_ROOT_USER_ACTION=ignore

RUN pip install \
    -r /tmp/requirements.txt \
    -c /tmp/constraints.txt \
    --no-cache-dir \
    && \
    rm /tmp/requirements.txt /tmp/constraints.txt
