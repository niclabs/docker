# net-viz dockerfiles

## Net-viz
Net-viz is a web application for the visualization and modification of physical networks.
For more information visit the project's [repository](https://www.github.com/niclabs/net-viz).

## Deploy Instructions

To deploy the net-viz project:

1. Edit the configuration file (`config.py`) with the desired values for the database name, user and password, as well as the data for the admin user in the application.
2. Build the docker images using the following command

  ```shell
  $ ./run.sh build
  ```
3. Create and populate the database giving as parameters the database name, the username and the password of the database (same as the ones given in the step 1):

  ```shell
  $ ./run.sh populate [-u <string : user_name_database> ] [-p <string : password>] [-d <string : database_name>]
  ```
3. After, run the containers, using the same parameters as the previous steps:

  ```shell
  $ ./run.sh run [-u <string : user_name_database> ] [-p <string : password>] [-d <string : database_name>]
  ```

## Content

### populate
Dockerfile to populate the database with initial information.

### server
Dockerfile for the server's flask application.

### config.py
File with the differents settings for the application

### nginx.conf
File with the nginx configuration

### run.sh
Bash script to deploy, run, start, restart, and stop the application and to
backup, restore the database data. The usage is:


```bash
# To build, start, restart, stop, delete, upgrade
$ ./run.sh build | start | restart | stop | delete | upgrade

# To run, populate
$ ./run.sh run | populate [-u <string : user_name_database> ] [-p <string : password>] [-d <string : database_name>]

# To backup or restore the database
$ ./run.sh backup | restore [-u <string : user_name_database> ] [-p <string : password>] [-d <string : database_name>] [-f <string : filename>]
```
