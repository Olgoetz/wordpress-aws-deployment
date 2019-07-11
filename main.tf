provider "aws" {

  region = var.region
  #shared_credentials_file=~/.aws/users/creds
  #profile= var.profile

}


###############################
######### AWS Lightsail
###############################



resource "aws_lightsail_key_pair" "wp_key_pair" {

  name       = "wordpress-key"
  public_key = file("~/.ssh/aws/wordpress/aws_lightsail.pub")

}



resource "aws_lightsail_instance" "wordpress" {

  name              = "wordpress"
  availability_zone = var.ls_instance_availability_zone
  blueprint_id      = var.ls_instance_blueprint_id
  bundle_id         = var.ls_instance_bundle_id
  key_pair_name     = aws_lightsail_key_pair.wp_key_pair.name

}


resource "aws_lightsail_static_ip" "wp_ip" {

  name = "wordpress-ip"

}


resource "aws_lightsail_static_ip_attachment" "wp_ip_attachment" {

  static_ip_name = aws_lightsail_static_ip.wp_ip.name
  instance_name  = aws_lightsail_instance.wordpress.name

}



###############################
######### Output
###############################


output "wp_static_ip" {

  value = aws_lightsail_static_ip.wp_ip.ip_address

}

