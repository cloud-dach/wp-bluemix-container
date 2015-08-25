FROM wordpress:latest

# JSON Parsing utility (shell)
ADD https://raw.githubusercontent.com/dominictarr/JSON.sh/master/JSON.sh /usr/local/bin/JSON.sh
RUN chmod u+x /usr/local/bin/JSON.sh

# Uses JSON.sh to parse and return VCAP_SERVICES
COPY vcap_parse.sh /vcap_parse.sh
RUN chmod u+x /vcap_parse.sh

# Uses vcap_parse.sh to export db credentials
COPY vcap_export.sh /vcap_export.sh
RUN chmod u+x /vcap_export.sh

# add supervisord to container
RUN apt-get update && apt-get install -y openssh-server supervisor
RUN mkdir -p /var/run/sshd /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD  id_rsa.pub /root/.ssh/id_rsa.pub
RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
# expose ports
EXPOSE 22 80
# Override Entrypoint
ENTRYPOINT ["/usr/bin/supervisord"]

