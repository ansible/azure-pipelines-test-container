FROM quay.io/bedrock/ubuntu:20.04

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    apt-transport-https \
    curl \
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

RUN curl https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb > packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    dotnet-runtime-3.1 \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s pip3 /usr/bin/pip

ADD requirements.txt /tmp/requirements.txt
ADD constraints.txt /tmp/constraints.txt

RUN sed 's|"$|:~/.local/bin"|' -i /etc/environment  # make sure non-root pip installed binaries are on the user's path

RUN pip install \
    -r /tmp/requirements.txt \
    -c /tmp/constraints.txt \
    --disable-pip-version-check \
    --no-cache-dir \
    --no-warn-script-location \
    && \
    rm /tmp/requirements.txt
