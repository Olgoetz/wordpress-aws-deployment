#!/bin/bash


echo -e "Starting Wordpress Deployment on AWS Lightsail...\n"


# -----> CHECKING IF CREDENTIALS FOR THE ACCOUNT TO DEPLOY ON EXIST


ACKI="AWS_ACCESS_KEY_ID"
ASAK="AWS_SECRET_ACCESS_KEY"


if [ ! -f access_keys.sh ]; then

    echo -e "Configuring the account to deploy on... \n"

    read -p "Please provide the AWS_ACCESS_KEY_ID: " ACKI

    read -p "Please provide the AWS_SECRET_ACCESS_KEY: " ASAK

# Write the environment variables to an extra file
    cat > access_keys.sh <<EOT
export AWS_ACCESS_KEY_ID=${ACKI}
export AWS_SECRET_ACCESS_KEY=${ASAK}
EOT
    

fi

chmod +x access_keys.sh

source ./access_keys.sh

 
# -----> GENERATING A KEY PAIR TO ENABLE SSH AGAINST THE INSTANCE



KEY_DIRECTORY=~/".ssh/aws/wordpress"

KEY_NAME="aws_lightsail.pem"

# Check if the key already exists and proceed appropriately

if [ ! -d $KEY_DIRECTORY ]; then

    mkdir -p $KEY_DIRECTORY

fi

if [ ! -f $KEY_DIRECTORY/$KEY_NAME ]; then

    echo -e "Generating SSH key pair...\n"

    ssh-keygen -m PEM -f $KEY_DIRECTORY/aws_lightsail -t rsa -b 4096 -N ""

    # Add the suffix ".pem" to the private key file
    mv $KEY_DIRECTORY/aws_lightsail $KEY_DIRECTORY/$KEY_NAME

    echo -e "SSH key generated!\n"


fi

 

# -----> START TERRAFORM TO DEPLOY THE RESSOURCES

echo -e "Executing terraform to start the deployment process...\n"

# Initialising terraform with the AWS provider plugin, otherwise exit the script
if terraform init ; then

    terraform plan -out myplan

    # Check the plan
    read -p "Plan ok (y/n)?: " OK

    if [ $OK = "y" ]; then

    # Conduct the deployment on the account
    terraform apply myplan

    echo -e "\nWordpress Deployment on AWS Lightsail finished!\n"

    WP_IP=$(terraform output wp_static_ip)

    echo -e "Your instance is located on $WP_IP\n"



# -----> CONNECTING TO THE INSTANCE VIA SSH TO RETRIEVE THE PASSWORD FOR GETTING ACCESS TO THE WORDPRESS BACKEND

    # Add the instance to know hosts
    echo -e "Adding the fingerprint to know_hosts"

    ssh-keyscan $WP_IP >> ~/.ssh/known_hosts



    # Check if host is available
    
    echo -e "Spinning up the instance...\n"

    while true; do
    
        AVAILABLE=$(ssh -i "$KEY_DIRECTORY/$KEY_NAME" bitnami@$WP_IP [ -e bitnami_application_password ] && echo 1) 

        if [ "${AVAILABLE}" ]; then
            echo "in if"
            break
        fi

    done

    echo -e "Instance spinned up!\n"

    echo -e "To login into the Wordpress backend got to $WP_IP/wp-login.php\n"

    echo -e "The user is: user\n"

    # Get the wordpress backend password
    echo -e "The password is: $(ssh -i "$KEY_DIRECTORY/$KEY_NAME" bitnami@$WP_IP cat bitnami_application_password)\n"



   else

        echo -e "\nDeployment procedure exited!"

    fi

else

    echo -e "Terraform execution failed!"

fi