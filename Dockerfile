FROM ubuntu:latest

MAINTAINER Jon Jenkins <jj@java2go.com> version: 0.1

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 wget curl locales && \
    DEBIAN_FRONTEND=noninteractive apt-get clean

ENV APACHE_TZ Europe/London
ENV LANGUAGE en_US.UTF-8 
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN echo $APACHE_TZ > /etc/timezone && \
	  dpkg-reconfigure -f noninteractive tzdata
	
RUN locale-gen en_US.UTF-8 && \
	  DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

ADD ./001-docker.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/001-docker.conf /etc/apache2/sites-enabled/

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
