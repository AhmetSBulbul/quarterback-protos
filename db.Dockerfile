FROM mariadb:10.5.8
COPY db.sql /docker-entrypoint-initdb.d/
