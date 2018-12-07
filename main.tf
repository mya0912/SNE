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
    name            = "name"
    values          = ["Windows_Server-2016-English-Nano*"]
  }

  most_recent       = true
}

#create ec2 instance
resource "aws_instance" "winserver" {
    ami             = "${data.aws_ami.test_iis_server.id}"
    instance_type   = "t3.micro"

    tags {
      description = "Alipui TF Test"
    }
}
