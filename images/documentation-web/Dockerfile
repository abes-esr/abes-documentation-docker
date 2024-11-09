FROM httpd:2.4.60

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
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

COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf
RUN mkdir -p /usr/local/apache2/conf/abes/ 
