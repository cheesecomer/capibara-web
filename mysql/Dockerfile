FROM mysql:5.7
ENV MYSQL_ROOT_PASSWORD password

COPY ./provisioning.sql /docker-entrypoint-initdb.d/provisioning.sql

VOLUME [ "/var/run/mysqld/" ]