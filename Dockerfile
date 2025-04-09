# Use the official Flyway image as the base
FROM flyway/flyway

# Copy the migrations to the appropriate location
COPY ./sql/migrations /flyway/sql

# Default command to run Flyway migration
CMD ["migrate", "-locations=filesystem:/flyway/sql"]