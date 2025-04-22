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
#     - nanofilt=2.8.0
#     - porechop=0.2.4
#     - minimap2=2.28
#     - fasttree=2.1.11
#     - mafft=7.520
#     - viral_consensus=0.0.4
#     - viralmsa=1.1.44
#     - raxml-ng=1.2.1
#     - gawk
#     - deeptools
#     - samtools
#     - pygenometracks 
#     - sed
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
        && . "/opt2/conda/etc/profile.d/conda.sh" \
        && . "/opt2/conda/etc/profile.d/mamba.sh" \
        && mamba env create -y --name mpox-seek --file=/opt2/mpox.yaml \
        && mamba clean --all -y \
        && rm -f /opt2/conda/Miniforge3_install.sh

# Install GNU which, increases compatiability
# with which distros included with Debian/Rocky
# linux installations, this version of which
# includes extra options that the ubuntu version 
# does not have. The gnu verison is backwards 
# compatiable with the ubunutu version.
RUN mkdir -p /opt2/ \
        && wget --no-check-certificate -O /opt2/which.tar.gz https://ftp.gnu.org/gnu/which/which-2.21.tar.gz \
        && tar -xvf /opt2/which.tar.gz -C /opt2/ \
        && rm /opt2/which.tar.gz \
        && cd /opt2/which-2.21/ \
        && ./configure --prefix=/opt2/which-2.21 \
        && make \
        && make install

################ POST #################
# Add Dockerfile and export environment 
# variables and set java8 as default with links
# to alternative versions
ADD Dockerfile /opt2/mpox-seek.dockerfile
RUN chmod -R a+rX /opt2
ENV PATH="/opt2/conda/envs/mpox-seek/bin:/opt2/which-2.21/bin:${PATH}"
WORKDIR /data2