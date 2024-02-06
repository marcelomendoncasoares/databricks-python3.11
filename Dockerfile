FROM databricksruntime/standard:experimental

ARG DEBIAN_FRONTEND=noninteractive

# Install the python on the machine
RUN sudo apt-get update \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get install -y build-essential bsdmainutils git python3.11 python3.11-dev python3.11-distutils \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove -y \
    && apt-get clean

# Remove the existing virtualenv
RUN sudo rm -rf /databricks/python3

# Create a new virtualenv with the new python version
RUN virtualenv --python=python3.11 --system-site-packages /databricks/python3 --no-download \
  && /databricks/python3/bin/pip install --upgrade pip setuptools wheel

# These python libraries are used by Databricks notebooks and the Python REPL
# https://github.com/databricks/containers/blob/master/ubuntu/python/Dockerfile
RUN /databricks/python3/bin/pip install \
    six \
    jedi \
    ipython \
    numpy \
    pandas~=1.5.3 \
    pyarrow \
    matplotlib \
    jinja2 \
    ipykernel \
    grpcio \
    grpcio-status \
    databricks-sdk
