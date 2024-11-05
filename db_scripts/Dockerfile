# Use the official MySQL image from the Docker Hub
FROM mysql:8.0

# Set environment variables for MySQL
ENV MYSQL_ROOT_PASSWORD=root_password
ENV MYSQL_DATABASE=xiso_db
ENV MYSQL_USER=root
ENV MYSQL_PASSWORD=r41ss4

# Create directory to hold SQL scripts and copy them
RUN mkdir -p /docker-entrypoint-initdb.d/
COPY xiso_db.sql /docker-entrypoint-initdb.d/
COPY inserts_plus.sql /docker-entrypoint-initdb.d/

# Set up a custom entrypoint
# COPY ./entrypoint.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the custom entrypoint script
# ENTRYPOINT ["entrypoint.sh"]

# Expose MySQL port
EXPOSE 3322
