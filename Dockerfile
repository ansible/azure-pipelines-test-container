FROM public.ecr.aws/docker/library/ubuntu:noble-20241118.1

# make sure non-root pip installed binaries are on the user's path
ENV PATH="${PATH}:~/.local/bin"

# Enable the deadsnakes PPA to provide additional packages.
COPY files/deadsnakes.gpg /etc/apt/keyrings/deadsnakes.gpg
COPY files/deadsnakes.list /etc/apt/sources.list.d/deadsnakes.list

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    docker.io \
    git \
    openssh-client \
    python3.11-venv \
    sudo \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# The python3-pip package depends on python3:all, which will install an additional Python interpreter.
# Downloading and installing the package this way avoids that issue, at the cost of breaking further package installs due to unmet dependencies.
RUN cd /tmp && \
    apt-get update -y && \
    apt-get download -y python3-pip && \
    dpkg --force-all -i /tmp/*.deb && \
    rm /usr/bin/pip3.12 && \
    rm /tmp/*.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s python3.11 /usr/bin/python3
RUN ln -s python3.11 /usr/bin/python

ADD requirements.txt /tmp/requirements.txt
ADD constraints.txt /tmp/constraints.txt

ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_ROOT_USER_ACTION=ignore

RUN pip install \
    -r /tmp/requirements.txt \
    -c /tmp/constraints.txt \
    --no-cache-dir \
    && \
    rm /tmp/requirements.txt /tmp/constraints.txt
