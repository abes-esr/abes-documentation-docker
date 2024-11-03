FROM abesesr/swish-e-docker:1.1.1

RUN apt-get update && apt-get -y install cron

# Copy swish-e-cron file to the cron.d directory
COPY ./swish-e-cron /etc/cron.d/swish-e-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/swish-e-cron

# Apply cron job
RUN crontab /etc/cron.d/swish-e-cron
 
# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Redirect cronjob log to docker log collector
RUN ln -sf /proc/$$/fd/1 /var/log/cron.log

ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone 

# Run updating indexes, crontab and apache
CMD /opt/guide/data-swish-e/scripts/indexerGM.sh && cron && apachectl -DFOREGROUND
