# jupyter-procmail
# Deliver:


## Setup Appliances for Workshops:
Necessary scripts to run set up for workshops appliances 
pre reqs:
- Workshop entry in front end DB
- Necessary infos in ansible variable file defining platform on which the Workshop will run (definied in plaftform yaml file in ansible-jupyter/group-vars/...)
- Necessary scripts:
    -setup-WKSHP-Workshop-name.sh.j2
    -In case of Docker Appliance:
      - Yaml file in ansible-jupyter folder:  ansible_setup_WKSHP-Dataspaces_appliance.yml
Step1:
* launch setup script for appliance (This script will prepare the appliance : adding pre reqs and users)
* ./setup-appliance.sh WKSHP-Workshop-name
*
