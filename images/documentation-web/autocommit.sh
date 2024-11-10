#!/bin/bash
cd /usr/local/apache2/htdocs/
git config --global --add safe.directory /usr/local/apache2/htdocs
git add .
git commit -am "autoupdate `date +%F-%T`"
git push origin main
