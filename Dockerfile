# set the base image first
FROM ubuntu:14.04

# specify maintainer
MAINTAINER John Lund <john@technomad.io>

# run update and install nginx, php-fpm and other useful libraries
RUN apt-get update -y && \
  apt-get install -y \
  nginx \
  curl \
  nano \
  git \
  php5-fpm \
  php5-cli \
  php5-intl \
  php5-mcrypt \
  php5-apcu \
  php5-gd \
  php5-curl \
  zsh \
  git-core

# Add config files
ADD init /init

# run init script
RUN chmod +x /init/init.sh
RUN /init/init.sh
VOLUME ["/var/www"]

# expose port 80
EXPOSE 80

# run nginx and php5-fpm on startup
RUN echo "/etc/init.d/php5-fpm start" >> /etc/bash.bashrc
RUN echo "/etc/init.d/nginx start" >> /etc/bash.bashrc


# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install ohmyzsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

# switch shell?
chsh -s `which zsh`

# fix security issue in php.ini, more info https://nealpoole.com/blog/2011/04/setting-up-php-fastcgi-and-nginx-dont-trust-the-tutorials-check-your-configuration/
RUN sed -i.bak "s@;cgi.fix_pathinfo=1@cgi.fix_pathinfo=0@g" /etc/php5/fpm/php.ini

# set timezone in php.ini
RUN sed -i".bak" "s/^\;date\.timezone.*$/date\.timezone = \"Europe\/Kiev\" /g" /etc/php5/fpm/php.ini
