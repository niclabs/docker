#!/bin/sh

YELLOW='\033[1;33m'
NC='\033[0m' # No Color
printf "${YELLOW}Running db init\n${NC}"
python manage.py db init
printf "${YELLOW}Running db migrate\n${NC}"
python manage.py db migrate
printf "${YELLOW}Running db upgrade\n${NC}"
python manage.py db upgrade
printf "${YELLOW}Running db populate\n${NC}"
python manage.py populate
printf "${YELLOW}Finished populating database\n${NC}"
