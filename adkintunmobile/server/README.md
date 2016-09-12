# adkintunmobile-server dockerfiles

## Adkintun Mobile Server
Adkintun Mobile is an android application project for monitoring QoS on mobile network. For more information, visit the repository of the project [here](https://www.github.com/niclabs/adkintunmobile), or the repository of the server [here](https://www.github.com/niclabs/adkintunmobile-server)

## Deploy Instructions

To deploy the adkintunmobile-server project:

* Edit the configuration file (`config.py`) with the desired values for the database name, user and password, and also with the data for the admin user in the application.
* Run `run.sh`, giving the same database parameters used in the step 1, for the database container creation, following the next structure:


```bash
$ ./run.sh [-u <string : user_name_database> ] [-p <string : password>] [-d <string : database_name>]
```


## Content

### populate
Dockerfile for populate the server with initial information.

### uwsgi
Dockerfile for the server application.
