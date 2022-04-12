FROM debian:bullseye-slim

ENV LANG C.UTF-8

#
# Install core stuff
#
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    apt-transport-https \
    ca-certificates \
    git \
    gnupg2 \
    tzdata \
    # Python build deps
    build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
    && rm -rf /var/lib/apt/lists/*

#
# Install pyenv and Python 3.x versions
#
ENV HOME="/root"
RUN curl https://pyenv.run | bash
ENV PYENV_ROOT="$HOME/.pyenv"
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"

# Add the pyenv-alias-latest-patch-version so we can reference minor versions without specific patch versions
RUN git clone https://github.com/upside-services/pyenv-alias-latest-patch-version.git $(pyenv root)/plugins/pyenv-alias-latest-patch-version

# Install all the versions we want, along with the latest pip in each version.
COPY install_python_versions.sh $HOME
RUN $HOME/install_python_versions.sh

# Install Python-based CLI tools via pipx
#
# Install pipx using Python 3.10.  Anything subsequently installed via pipx will use this Python versions.
RUN PYENV_VERSION=3.10 python -m pip install --user pipx
ENV PATH="$PATH:$HOME/.local/bin"

# Install poetry
RUN pipx install poetry

# Install tox
RUN pipx install tox

