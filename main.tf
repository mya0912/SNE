#initialize terraform and specify backend
terraform{
  backend "s3"{}
}
#specify provider and region
provider "aws" {
    region = "${var.region}"
}

#this section is to define networking resources - VPC, Security Groups, ELB, etc.

/*this section is to define compute Resources
#query ami id for ec2 instance creation*/
data "aws_ami" "test_iis_server" {

  filter{
    name = "name"
    values = ["Windows_Server-2016-English*"]
  }

  most_recent = true
}

#create ec2 instance
resource "aws_instance" "winserver" {
    ami = "${data.aws_ami.test_iis_server.id}"
    instance_type = "t3.micro"
    key_name = "malipui-venv-kp"

    tags {
      Name = "Alipui-tftest"
      description = "test resource creation with terraform"
    }
}

#import keypair for ssh/rdp access
resource "aws_key_pair" "deployer-kp"{
    key_name = "malipui-venv-kp"
    public_key = "${var.publickey}"
  }
