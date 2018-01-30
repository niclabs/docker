# adkintunmobile dockerfiles

## Adkintun Mobile
Adkintun Mobile is an android application project for monitoring QoS on mobile network. For more information, visit the repository of the project [here](https://www.github.com/niclabs/adkintunmobile).

The application is divided in modules. Each subdirectory here handles a separate module.

## Deploy Instructions

To deploy all modules follow these instructions.


1. Go to the [server](https://sss.cl) subdirectory and follow the instructions there to run the main server containers.
2. Go to the [reports-backend](https://sss.cl) subdirectory and follow the instructions there to run the reports-backend containers.
3. Go to the [reports-generation](https://sss.cl) subdirectory and follow the instructions there to run the report generator container.
4. Go to the [user-login](https://sss.cl) subdirectory and follow the instructions there to run the websocket container used for user login.
5. Go to the [nginx](https://sss.cl) subdirectory and follow the instructions there to run the nginx container, which will connect to the other containers to forward them requests to serve.
