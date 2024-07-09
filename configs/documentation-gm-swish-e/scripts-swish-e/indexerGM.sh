#!/bin/bash
# Version 1.0

cd /var/www/html
swish-e -f /opt/guide/data-swish-e/indexTout.swish-e -c /opt/guide/data-swish-e/swishTout.conf
echo "indexation tout terminee"
swish-e -f /opt/guide/data-swish-e/indexCatalogage.swish-e -c /opt/guide/data-swish-e/swishCatalogage.conf
echo "indexation catalogage terminee"
swish-e -f /opt/guide/data-swish-e/indexManuels.swish-e -c /opt/guide/data-swish-e/swishPourManuels.conf
echo "indexation manuels terminee"