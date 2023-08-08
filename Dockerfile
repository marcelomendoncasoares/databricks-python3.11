FROM databricksruntime/standard:experimental

ARG DEBIAN_FRONTEND=noninteractive

# Install the python on the machine
RUN sudo apt-get update \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get install -y build-essential python3.11 python3.11-dev python3.11-distutils \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove -y \
    && apt-get clean

# Backup the original virtualenv requirements and remove it
RUN /databricks/python3/bin/pip freeze > /tmp/requirements.txt \
    && sudo rm -rf /databricks/python3

# Replace libs not compatible with the python version
RUN sed 's/numpy==1.21.5/numpy~=1.25/g' /tmp/requirements.txt > /tmp/requirements.txt

# Initialize the default environment that Spark and notebooks will use
RUN virtualenv -p python${version} --system-site-packages /databricks/python3 \
    && /databricks/python3/bin/pip install --upgrade pip \
    && /databricks/python3/bin/pip install -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt
