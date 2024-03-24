provider "aws" {
  region = "us-west-2"
}


resource "aws_instance" "Web-Server" {
  ami = var.linux-ami
  instance_type = "t2.micro"
  security_groups = [ var.all-allowed-sg ]
  subnet_id = var.pub-sub-a
  user_data = <<-EOF
    #!/bin/bash
    sudo su -
    sudo yum update -y
    yum install httpd -y
    systemctl start httpd 
    EOF
    
    tags = {
        Name = "Web-Server"
    }
}

resource "aws_instance" "App-Server" {
  ami = var.linux-ami
  instance_type = "t2.micro"
  security_groups = [ var.all-allowed-sg ]
  subnet_id = var.pub-sub-a
  user_data = <<-EOF
    #!/bin/bash
    sudo su -
    sudo yum update -y
    sudo dnf update
    yum update -y
    wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.87/bin/apache-tomcat-9.0.87.tar.gz
    tar -xvzf apache-tomcat-9.0.87.tar.gz
    mv apache-tomcat-9.0.87.tar.gz /opt
    yum install java -y
    EOF
    tags = {
        Name = "App-Server"
    }
}

resource "aws_instance" "JMG-Server" {
  ami = var.ubuntu-ami
  instance_type = "t2.micro"
  security_groups = [ var.all-allowed-sg ]
  subnet_id = var.pub-sub-a
  user_data = <<-EOF
    sudo su -
    sudo apt-get update -y
    sudo apt-get update -y
    sudo apt install openjdk-11-jdk -y
    curl -fsSL http://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]  https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt update
    sudo apt install jenkins -y
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
  EOF
    tags = {
        Name = "JMG-Server"
    }
}

output "Public-Ip-JMG-Server" {
  value = aws_instance.JMG-Server.public_ip
  }

/**
resource "aws_instance" "J-Server" {
  instance_type = "t2.micro"
  ami= var.linux-ami
  subnet_id = "subnet-00feea2234ce14160"
  security_groups = [ var.all-allowed-sg ]
   user_data = <<-EOF
    #!/bin/bash
    sudo su -
    sudo yum update -y
    sudo dnf update
    sudo dnf install java-11-amazon-corretto -y
    sudo wget -O /etc/yum.repos.d/jenkins.repo     https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo dnf install jenkins -y
    jenkins --version
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    sudo systemctl status jenkins
    wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
    tar -xvzf apache-maven-3.9.6-bin.tar.gz
    mv apache-maven-3.9.6-bin.tar.gz /opt

    EOF

    tags = {
        Name = "J-Server"
    }

}
**/
