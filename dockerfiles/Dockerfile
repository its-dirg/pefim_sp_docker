FROM itsdirg/dirg_base

MAINTAINER DIRG <dirg@its.umu.se>

VOLUME ["/opt/pefim/etc"]

ADD requirements.txt /opt/pefim/requirements.txt

RUN apt-get update
RUN apt-get install -y --no-install-recommends\
        libsasl2-dev \
        libldap2-dev \
        libssl-dev \
        xmlsec1
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# install the pefim idp
RUN pip install --upgrade pip
RUN pip install -r /opt/pefim/requirements.txt
RUN pip install git+https://github.com/its-dirg/pefim_sp.git#egg=pefim_sp

ADD start.sh /start.sh

WORKDIR /

CMD ["bash", "/start.sh"]
