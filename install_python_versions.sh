#!/bin/bash
#
# Prerequisites: Pyenv is installed with the pyenv-alias-latest-patch-version plugin.  See
# https://raw.githubusercontent.com/upside-services/python-setup-scripts/master/install_pyenv.sh


PYTHON_VERSIONS=(3.6 3.7 3.8 3.9 3.10)

for python_version in ${PYTHON_VERSIONS[@]}; do
    echo "Installing latest Python ${python_version}"
    pyenv install ${python_version}:latest
    PYENV_VERSION=${python_version} python -m pip install --upgrade pip wheel
done

# Set the default version to 3.6
# This lets 3.6 be ambient for projects that don't yet have .python-version.
# So by default `python` will map to 3.6.
# Other versions are added to support tox which invokes python using major and minor, like `python3.7`
# Without declaring these `global` pyenv will error with `pyenv: foo: command not found`
pyenv global ${PYTHON_VERSIONS[@]}
