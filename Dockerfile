FROM databricksruntime/standard:13.3-LTS

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

# Create a new virtualenv with the python language server
RUN virtualenv --python=python3.11 --system-site-packages /databricks/python-lsp --no-download \
  && /databricks/python-lsp/bin/pip install --upgrade pip setuptools wheel

# Specifies where Spark will look for the python process
ENV PYSPARK_PYTHON=/databricks/python3/bin/python3

# These python libraries are used by Databricks notebooks and the Python REPL
# You do not need to install pyspark - it is injected when the cluster is launched
COPY requirements/* /databricks/.
RUN /databricks/python3/bin/pip install -r /databricks/requirements.txt
RUN /databricks/python-lsp/bin/pip install -r /databricks/python-lsp-requirements.txt
