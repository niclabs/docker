# adkintunmobile dockerfiles

## Adkintun Mobile Reports Generation
Adkintun Mobile is an android application project for monitoring QoS on mobile network. For more information, visit the repository of the project [here](https://www.github.com/niclabs/adkintunmobile).
This module handles the nginx container that serves requests on the server by forwarding to to other application containers.

## Deploy Instructions

This assumes you are already running the server and reports-backend modules with their respective databases. To deploy this project:

1. Edit the configuration file (`nginx.conf`) with the desired values for the other containers' names and their ports. The file looks like the following:
```

server{
       	listen 80;
        location / {
        include uwsgi_params;
        uwsgi_pass server-adk:8000;
        client_max_body_size 31M;
        }
}

server{
       	listen 8080;
        location / {
        include uwsgi_params;
        uwsgi_pass adk-report-backend:8000;
        client_max_body_size 31M;
        }

}
```
2. Edit the `run.sh` script to make sure the container name and port variable match those of the `nginx.conf` file.

3. Run the nginx container:
```
$ ./run.sh run
```
This will create the nginx container and connect it with the other application containers in order to forward requests to them. The nginx container will expose the specified ports to receive requests.

Sometimes when upgrading an application container the nginx container will be unable to reconnect to it automatically, in this case you should restart the nginx container using the `restart` command from the `run.sh` script.
```
$ ./run.sh restart
```



## Content

### nginx.conf
File with the differents settings for the nginx server

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
