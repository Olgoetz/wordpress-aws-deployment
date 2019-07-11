#!/bin/bash

# ----> EXPORT THE ACCOUNT CREDENTIALS AS ENVIRONMENT VARIALBES

chmod +x access_keys.sh

source ./access_keys.sh

# ----> DESTROY THE RESSOURCES

terraform destroy

read -p "Do you want remove the credentials (y/n)?: " OK

if [ $OK = "y" ]; then
    rm access_keys.sh
fi