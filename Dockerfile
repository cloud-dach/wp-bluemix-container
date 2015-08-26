FROM php:5.6-apache

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd
RUN docker-php-ext-install mysqli

VOLUME /var/www/html

ENV WORDPRESS_VERSION 4.1.2
ENV WORDPRESS_UPSTREAM_VERSION 4.1.2
ENV WORDPRESS_SHA1 9e9745bb8a1166622de866076eac73a49cb3eba0

# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_UPSTREAM_VERSION}.tar.gz \
	&& echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
	&& tar -xzf wordpress.tar.gz -C /usr/src/ \
	&& rm wordpress.tar.gz \
	&& chown -R www-data:www-data /usr/src/wordpress

COPY docker-entrypoint.sh /entrypoint.sh

# JSON Parsing utility (shell)
ADD https://raw.githubusercontent.com/dominictarr/JSON.sh/master/JSON.sh /usr/local/bin/JSON.sh
RUN chmod u+x /usr/local/bin/JSON.sh

# Uses JSON.sh to parse and return VCAP_SERVICES
COPY vcap_parse.sh /vcap_parse.sh
RUN chmod u+x /vcap_parse.sh

# Uses vcap_parse.sh to export db credentials
COPY vcap_export.sh /vcap_export.sh
RUN chmod u+x /vcap_export.sh

# add supervisord ssh and mc to container
RUN apt-get update && apt-get install -y openssh-server supervisor mc
RUN mkdir -p /var/run/sshd /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD  id_rsa.pub /root/.ssh/id_rsa.pub
RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
# expose ports
EXPOSE 22 80
# Override Entrypoint
ENTRYPOINT ["/usr/bin/supervisord"]

