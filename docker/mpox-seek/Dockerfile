# Base image for mpox-seek,
# uses Ubuntu Jammy (LTS)
FROM ubuntu:22.04

# Depedencies of pipeline, see 'mpox.yaml' for latest:
#   name: mpox-seek
#   channels:
#     - conda-forge
#     - bioconda
#     - defaults
#     - r
#   dependencies:
#    - nanofilt=2.8.0
#    - porechop=0.2.4
#    - minimap2=2.28
#    - fasttree=2.1.11
#    - mafft=7.520
#    - viral_consensus=0.0.4
#    - raxml-ng=1.2.1
#    - gawk
LABEL maintainer=kuhnsa@nih.gov

############### INIT ################
# Create Container filesystem specific 
# working directory and opt directories
# to avoid collisions with the host's
# filesystem, i.e. /opt and /data
RUN mkdir -p /opt2 && mkdir -p /data2
WORKDIR /opt2 

# Set time zone to US east coast 
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
        && echo $TZ > /etc/timezone

############### SETUP ################
# This section installs system packages 
# required for your project. If you need 
# extra system packages add them here.
RUN apt-get update \
    && apt-get -y upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        bzip2 \
        ca-certificates \
        curl \
        gawk \
        git \
        gzip \
        locales \
        make \
        python3 \
        python3-pip \
        python3-requests \
        python3-pandas \
        unzip \
        wget \
        zlib1g-dev \
    && apt-get clean && apt-get purge \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the locale
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# Make python3 the default interpreter
# and install Python Packages 
RUN ln -sf /usr/bin/python3.10 /usr/bin/python
RUN pip3 install --upgrade pip 

############### INSTALL ################
# Install conda and mamba and create an
# environment called, mpox-seek from the
# following file: mpox.yaml
COPY mpox.yaml /opt2/mpox.yaml
RUN mkdir -p /opt2/conda/ \
        && wget -O /opt2/conda/Miniforge3_install.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" \
        && bash /opt2/conda/Miniforge3_install.sh -b -f -p /opt2/conda/ \
        && source "/opt2/conda/etc/profile.d/conda.sh" \
        && source "/opt2/conda/etc/profile.d/mamba.sh" \
        && mamba env create -y --name mpox-seek --file=/opt2/mpox.yaml \
        && mamba clean --all -y

################ POST #################
# Add Dockerfile and export environment 
# variables and set java8 as default with links
# to alternative versions
ADD Dockerfile /opt2/mpox-seek.dockerfile
RUN chmod -R a+rX /opt2
ENV PATH="/opt/conda/envs/mpox-seek/bin:${PATH}"
WORKDIR /data2