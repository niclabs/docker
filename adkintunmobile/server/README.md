# adkintunmobile-server dockerfiles

## Adkintun Mobile Server
Adkintun Mobile is an android application project for monitoring QoS on mobile network. For more information, visit the repository of the project [here](https://www.github.com/niclabs/adkintunmobile), or the repository of the server [here](https://www.github.com/niclabs/adkintunmobile-server)

## Deploy Instructions

To deploy the adkintunmobile-server project:

1. Edit the configuration file (`config.py`) with the desired values for the database name, user and password, and also with the data for the admin user in the application.
2. Build the docker images using the following command

  ```shell
  $ ./run.sh build
  ```
3. After, run the containers , giving as parameters the database name, the username and the password of the database (the same given in the step 1):

  ```shell
  $ ./run.sh run [-u <string : user_name_database> ] [-p <string : password>] [-d <string : database_name>]
  ```
## Content

### populate
Dockerfile for populate the server with initial information.

### server
Dockerfile for the server application.

### config.py
File with the differents settings for the application

### run.sh
Bash script for deploy, run, start, restart, and stop the application. The usage is:


```bash
# For build, start, restart, stop, delete, upgrade
$ ./run.sh build | start | restart | stop | delete | upgrade_app

# For run
$ ./run.sh run [-u <string : user_name_database> ] [-p <string : password>] [-d <string : database_name>]
```
