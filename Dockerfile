FROM httpd:2.4.60

COPY ./configs/documentation-web/httpd.conf /usr/local/apache2/conf/httpd.conf
RUN mkdir -p /usr/local/apache2/conf/abes/ 
