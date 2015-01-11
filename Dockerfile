FROM ubuntu:latest

MAINTAINER Jon Jenkins <jj@java2go.com> version: 0.1

ENV PRIMARY_LANGUAGE en
#ENV SECONDARY_LANGUAGES :fr:de
ENV SECONDARY_LANGUAGES :
ENV PRIMARY_COUNTRY GB 
ENV PRIMARY_CHARSET UTF-8 
ENV PRIMARY_TZ Europe/London

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  language-pack-$PRIMARY_LANGUAGE apache2 wget curl && \
    DEBIAN_FRONTEND=noninteractive apt-get clean

RUN echo $PRIMARY_TZ > /etc/timezone && \
	  dpkg-reconfigure -f noninteractive tzdata

ENV LANGUAGE $PRIMARY_LANGUAGE$SECONDARY_LANGUAGES
ENV LANG $PRIMARY_LANGUAGE.$PRIMARY_COUNTRY.$PRIMARY_CHARSET
ENV LC_ALL $PRIMARY_LANGUAGE.$PRIMARY_COUNTRY.$PRIMARY_CHARSET

ADD ./001-docker.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/001-docker.conf /etc/apache2/sites-enabled/

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.localhost
ENV APACHE_DOCUMENTROOT /var/www

EXPOSE 80

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
