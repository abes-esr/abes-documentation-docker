FROM httpd:2.4.60

COPY ./volumes/documentation-dockerfile/httpd.conf /usr/local/apache2/conf/httpd.conf
RUN mkdir -p /usr/local/apache2/conf/abes/

