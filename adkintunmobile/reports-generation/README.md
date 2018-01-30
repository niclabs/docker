# adkintunmobile dockerfiles

## Adkintun Mobile Reports Generation
Adkintun Mobile is an android application project for monitoring QoS on mobile network. For more information, visit the repository of the project [here](https://www.github.com/niclabs/adkintunmobile).
This module handles the monthly report generation.

## Deploy Instructions

This assumes you are already running the server and reports-backend modules with their respective databases. To deploy this project:
1. Build the docker images:
```
$ ./run.sh build
```

2. Edit the configuration file (`config.py`) with the desired values for the username and password on both databases.

3. Run the generator container:
```
$ ./run.sh run
```
This will create the generator container and connect it to the database using the credentials from the `config.py` file. Once a month it will create the report files on the `reports` directory. It will also update the reports database.

Once the application is running you can upgrade the server to a new version by editing the Dockerfile in the server folder to pull a more recent commit then run:
```
$ ./run.sh upgrade
```

You can also manually generate a report for any month with the `report` command:
```
$ ./run.sh report [-y <int : year> ] [-m <int : month>]
```
This will create a container to generate a single report.


## Content

### Dockerfile
Dockerfile for the reports generator application.

### config.py
File with the differents settings for the application

### run.sh
Bash script to deploy, run, start, restart, and stop the application. The usage is:


```bash
Usage: ./run.sh COMMAND
    Program to manage the server-report containers

    Commands:
    build     Build docker images
    delete    Delete docker container for the report generator
    help      Display this message
    run       Create and run docker container for the report generator
    start     Start docker container for the report generator
    stop      Stop docker container for the report generator
    upgrade   Rebuild and restart docker container for the report generator
    report    Generate and import reports for the specified month and year
```
