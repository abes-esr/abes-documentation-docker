#!/bin/bash
# Version 1.0

docker run --restart always -d --name documentation-gm-swish-e  \
-p 8080:80  \
-v /var/www/html/guide/html/:/var/www/html/ \
-v /opt/guide/data-swish-e/.swishcgi.conf:/usr/lib/cgi-bin/.swishcgi.conf \
-v /opt/guide/data-swish-e/:/opt/guide/data-swish-e/ \
mylocalswish-e:latest
