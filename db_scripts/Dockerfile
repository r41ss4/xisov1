# Use the official MySQL image from the Docker Hub
FROM mysql:8.0

# Set environment variables for MySQL
ENV MYSQL_ROOT_PASSWORD=root_password
ENV MYSQL_DATABASE=xiso_db

# Create directory to hold SQL scripts and copy them
RUN mkdir -p /docker-entrypoint-initdb.d/
COPY xiso_db.sql /docker-entrypoint-initdb.d/
COPY inserts_plus.sql /docker-entrypoint-initdb.d/

# Ensure the log directory exists
RUN mkdir -p /var/log/mysql

# Copy custom MySQL configuration
COPY my.cnf /etc/mysql/my.cnf

# Expose MySQL port
EXPOSE 3306

# Start the MySQL server when the container is run
CMD ["mysqld"]
