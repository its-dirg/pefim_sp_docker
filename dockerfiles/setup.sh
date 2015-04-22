#!/bin/bash

apt-get update
apt-get install -y --no-install-recommends\
        libsasl2-dev \
        libldap2-dev \
        libssl-dev \
        xmlsec1
apt-get clean
rm -rf /var/lib/apt/lists/*

# install the pefim idp
pip install --system-site-packages --upgrade pip
pip install -r /opt/pefim/requirements.txt
pip install git+https://github.com/its-dirg/pefim_sp.git#egg=pefim_sp