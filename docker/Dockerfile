FROM debian:buster

ENV TZ=America/Sao_Paulo
ARG DEBIAN_FRONTEND=noninteractive

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update && apt upgrade && apt install -y -qq g++ make wget patch libedit-dev uuid-dev libjansson-dev libxml2-dev sqlite3 libsqlite3-dev libssl-dev
RUN cd /usr/src && wget https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-17-current.tar.gz \
	&& tar xvzf asterisk-17-current.tar.gz && rm asterisk-17-current.tar.gz \
	&& cd asterisk-17.4.0 \
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
### Backup original conf files
#  for f in /etc/asterisk/*.conf; do cp -- "$f" "${f%.conf}.sample"; done && \
#  mkdir /etc/asterisk/samples && mv /etc/asterisk/*.sample /etc/asterisk/samples/ && \
### Make conf files prettier
#  for f in /etc/asterisk/*.conf; do sed -i '/^$/d' $f; sed -i '/^\s*;/d' $f; done && \
### Clean up files
	&& apt-get -y autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /usr/src/*

#EXPOSE 5060 5061

VOLUME /etc/asterisk /var/lib/asterisk /var/spool/asterisk

CMD ["asterisk", "-f"]
