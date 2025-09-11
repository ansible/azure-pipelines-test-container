FROM public.ecr.aws/docker/library/ubuntu:noble-20250714

# make sure non-root pip installed binaries are on the user's path
ENV PATH="${PATH}:~/.local/bin"

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    docker.io \
    git \
    openssh-client \
    python-is-python3 \
    python3-pip \
    python3-venv \
    sudo \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD files/requirements.txt /tmp/requirements.txt
ADD files/constraints.txt /tmp/constraints.txt

ENV PIP_BREAK_SYSTEM_PACKAGES=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_ROOT_USER_ACTION=ignore

RUN pip install \
    -r /tmp/requirements.txt \
    -c /tmp/constraints.txt \
    --no-cache-dir \
    && \
    rm /tmp/requirements.txt /tmp/constraints.txt
