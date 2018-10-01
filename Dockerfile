FROM ruby:2.3.1

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get update && \
    apt-get -y install nodejs && \
    apt-get -y clean
RUN gem install bundler smashing
RUN mkdir /smashing && \
    smashing new smashing && \
    cd /smashing && \
    bundle && \
    ln -s /smashing/dashboards /dashboards && \
    ln -s /smashing/jobs /jobs && \
    ln -s /smashing/assets /assets && \
    ln -s /smashing/lib /lib-smashing && \
    ln -s /smashing/public /public && \
    ln -s /smashing/widgets /widgets && \
    mkdir /smashing/config && \
    mv /smashing/config.ru /smashing/config/config.ru && \
    ln -s /smashing/config/config.ru /smashing/config.ru && \
    ln -s /smashing/config /config

COPY run.sh /

RUN apt-get install -y wget && \
    apt-get install -y build-essential && \
    apt-get install -y libc6-dev && \
    wget ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.00.27.tar.gz && \
    tar -xzf freetds-1.00.27.tar.gz && \
    cd freetds-1.00.27 && \
    ./configure --prefix=/usr/local --with-tdsver=7.3 && \
    make && \
    make install

VOLUME ["/dashboards", "/jobs", "/lib-smashing", "/config", "/public", "/widgets", "/assets"]

ENV PORT 3030
EXPOSE $PORT
WORKDIR /smashing

CMD ["/run.sh"]
