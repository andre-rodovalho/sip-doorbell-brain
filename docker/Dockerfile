FROM debian:bullseye

ENV ASTERISK_VERSION 18.11.2
ENV ASTERISK_PACKAGE asterisk-${ASTERISK_VERSION}.tar.gz
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get -y upgrade -qq && apt-get install -y --no-install-recommends --no-install-suggests \
        g++ make wget patch libedit-dev uuid-dev libjansson-dev libxml2-dev sqlite3 libsqlite3-dev libssl-dev \
        && cd /usr/src && wget http://downloads.asterisk.org/pub/telephony/asterisk/${ASTERISK_PACKAGE} \
        && tar xvzf ${ASTERISK_PACKAGE} && rm ${ASTERISK_PACKAGE} && cd asterisk-${ASTERISK_VERSION} \
        && echo y | ./contrib/scripts/install_prereq install && echo y | ./contrib/scripts/get_mp3_source.sh \
        && ./configure \
        && make menuselect.makeopts && menuselect/menuselect \
                --disable BUILD_NATIVE \
                --enable format_mp3 \
                --disable-category MENUSELECT_CORE_SOUNDS \
                --disable-category MENUSELECT_MOH \
                --disable-category MENUSELECT_EXTRA_SOUNDS \
                  menuselect.makeopts \
        && make && make install && make samples && ldconfig \
        && apt-get -y autoremove \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /usr/src/* /tmp/* /var/tmp/*

VOLUME /etc/asterisk /var/lib/asterisk /var/spool/asterisk

CMD ["asterisk", "-f"]
