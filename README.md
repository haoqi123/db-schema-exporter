### DB Schema Exporter
Introduction
DB Schema Exporter is a command-line tool that exports the database schema of a MySQL database to a specified file path. It can be used for backups, version control, or any other purpose that requires the database schema to be saved in a file.

### Getting Started
#### Prerequisites
* Docker
* Docker Compose
#### Usage
1. Clone this repository.
2. Open a terminal and navigate to the project directory.
3. Run docker-compose up to start the DB Schema Exporter container.
4. Access the container by running docker-compose exec db-schema-exporter sh.
5. Run the command ./db-schema-exporter to export the database schema to the specified file path.
6. The exported schema file will be available in the export directory of the project directory.
#### Configuration
The following environment variables can be configured in the docker-compose.yml file:

* DB_USER: The MySQL database user.
* DB_PASSWORD: The MySQL database password.
* DB_HOST: The MySQL database host.
* DB_NAME: The MySQL database name.
* EXPORT_FILE_PATH: The file path to export the database schema to.
* CRON_EXPR: The cron expression used to schedule automatic schema exports.
### License
This project is licensed under the APACHE2.0 License - see the LICENSE.md file for details.
