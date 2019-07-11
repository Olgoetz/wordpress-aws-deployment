# Quick and automated deployment of a Wordpress instance on AWS

## Prerequisites

- AWS Account
- AWS User with progammatic access and full access to AWS Lightsail
- Terraform Version =>0.12.0
- Terminal (bash or shell)

## Introduction

AWS Lightsail is service to easily provision a server or application. This repo contains code to deploy a Wordpress instance based on the bitnami image. The process is fully automated.

## How to deploy

Navigate into the folder where `deploy_wordpress.sh` is located. Make sure have the correct rights to execute the script by executing:

```bash
$ chmod +x deploy_wordpress.sh
```

Then run:

```bash
$ ./deploy_wordpress.sh
```

All ressourcess will be deployed with terraform. After the successful deployment, you receive the ip address of the server. Furthermore you receive information how to log into your Wordpress backend.

The deployment will take around 2min.

## How to destroy

For destroying all ressources simply run:

```bash
$ ./destroy_wordpress.sh
```
