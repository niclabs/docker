# adkintunmobile dockerfiles

## Adkintun Mobile Reports Backend
Adkintun Mobile is an android application project for monitoring QoS on mobile network. For more information, visit the repository of the project [here](https://www.github.com/niclabs/adkintunmobile).
This module handles the backend for the adkintunmobile website.

## Deploy Instructions

To deploy the project:
1. Build the docker images:
```
$ ./run.sh build
```
2. First you need to create and run the database container, if you already have a running copy of the database skip this step.
- To create the database container:
```
$ ./run.sh rundb [-u <string : user_name_database> ] [-p <string : password>]
```
- To create the database with initial data:
```
$ ./run.sh populate
```

3. Edit the configuration file (`config.py`) with the desired values for the username and password, and also with the data for the admin user in the application.
4. Run the server container:
```
$ ./run.sh runserver
```
This will create the server container and connect it to the database using the credentials from the `config.py` file.

Once the application is running you can upgrade the server to a new version by editing the Dockerfile in the server folder to pull a more recent commit then run:
```
$ ./run.sh upgrade
```
You may need to restart the nginx container if it doesn't automatically reconnect to the new adkintun server container.

## Content

### populate
Dockerfile for populate the server with initial information.

### server
Dockerfile for the server application.

### config.py
File with the differents settings for the application

### run.sh
Bash script to deploy, run, start, restart, and stop the application. The usage is:


```bash
Usage: ./run.sh COMMAND
    Program to manage the server-report containers

    Commands:
    backup    Backup database to file
    build     Build docker images
    delete    Delete docker container for the server
    help      Display this message
    login     Log into the database
    populate  Populate database with initial data
    restore   Restore database with data from file
    rundb     Create and start docker container for database
    runserver Run docker container for the server
    start     Start docker container for the server
    stop      Stop docker container for the server
    upgrade   Rebuild and restart docker container for the  server

```
