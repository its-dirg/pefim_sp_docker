FROM itsdirg/dirg_base

MAINTAINER DIRG <dirg@its.umu.se>

VOLUME ["/opt/pefim/etc"]

ADD requirements.txt /opt/pefim/requirements.txt

ADD setup.sh /opt/pefim/setup.sh
RUN /opt/pefim/setup.sh

ADD start.sh /start.sh

WORKDIR /

CMD ["bash", "/start.sh"]
