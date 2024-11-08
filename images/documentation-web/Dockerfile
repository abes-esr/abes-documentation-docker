FROM httpd:2.4.60

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        curl \
        vim \
        git; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf
RUN mkdir -p /usr/local/apache2/conf/abes/ 
