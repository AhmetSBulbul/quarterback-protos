FROM mariadb:10.5.8
COPY *.sql /docker-entrypoint-initdb.d/
