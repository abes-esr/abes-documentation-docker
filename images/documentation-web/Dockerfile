FROM httpd:2.4.60

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        cron \
	curl \
        vim \
	openssh-client \
        git; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Créer le répertoire .ssh
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Injecter la clé privée depuis une variable d'environnement
ARG SSH_PRIVATE_KEY
RUN echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa

# Copier le fichier de configuration SSH
COPY ssh_config /root/.ssh/config

# Copy autocommit.sh script
COPY ./autocommit.sh /opt/guide/scripts/

# Give execution rights
RUN chmod +x /opt/guide/scripts/autocommit.sh

# Copy autocommit-cron file to the cron.d directory
COPY ./autocommit-cron /etc/cron.d/autocommit-cron

# Set read and write permissions on the cron job file
RUN chmod 0644 /etc/cron.d/autocommit-cron

# Apply cron job
RUN crontab /etc/cron.d/autocommit-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Redirect cronjob log to docker log collector
RUN ln -sf /proc/$$/fd/1 /var/log/cron.log

ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf
RUN mkdir -p /usr/local/apache2/conf/abes/ 

# Run crontab and apache
CMD cron && apachectl -DFOREGROUND
