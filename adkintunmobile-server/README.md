# AdkintunMobile-Server Deploy
Script and dockerfiles to deploy AdkintunMobile-Server.

Previously run `run.sh` is important:

1) Edit the configuration file (`config.py`) with the desired values for the database name, user and password, and also with the data for the admin user in the application.

2) Run `run.sh`, giving the same database parameters used in the step 1, for the database container creation, following the next structure:


```bash
$ ./run.sh [-u <string : user_name_database> ] [-p <string : password>] [-d <string : database_name>]
```

Just wait.