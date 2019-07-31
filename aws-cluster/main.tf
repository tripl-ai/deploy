# Create a new instance of the latest Ubuntu 14.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"

provider "aws" {
  region = "${var.aws_region}"
}

// create a uuid which is used to track job and resources
resource "random_uuid" "uuid" { }


# Fetch the AWS ECS Optimized Linux AMI name
data "aws_ami" "amzn2-ami-ecs-hvm" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"]
  }
}

data "template_file" "user_data_null" {
  template = file("${path.module}/templates/user-data-null.sh")
  vars = {}
}

data "template_file" "user_data_single_ssd" {
  template = file("${path.module}/templates/user-data-single-ssd.sh")
  vars = {}
}

data "template_file" "user_data_raid0_ssd" {
  template = file("${path.module}/templates/user-data-raid0-ssd.sh")
  vars = {}
}

resource "aws_instance" "arc_master" {
  ami                         = "${data.aws_ami.amzn2-ami-ecs-hvm.id}"
  instance_type               = "${var.master_instance_type}"
  key_name                    = "${var.key_name}"
  user_data                   = "${data.template_file.user_data_null.rendered}"
  associate_public_ip_address = true

  tags = {
    Name                      = "${random_uuid.uuid.result}-arc-master"
    destroy_after             = "${var.destroy_after}"
  }

  provisioner "remote-exec" {
    connection {
      host        = "${self.public_ip}"
      user        = "ec2-user"
      private_key = "${file(var.private_key)}"
    }    

    inline = [
      "docker run -d --net host --hostname $(hostname) -e\"SPARK_LOCAL_IP=$(hostname -i)\" -e \"SPARK_PUBLIC_DNS=$(hostname -i)\" -e \"SPARK_DAEMON_JAVA_OPTS=-XX:+UseG1GC -XX:-UseGCOverheadLimit -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap\" triplai/arc:${var.docker_tag} /bin/bash -c \"rm /opt/spark/conf/log4j.properties;bin/spark-class org.apache.spark.deploy.master.Master\""
    ]
  }  
}

resource "aws_instance" "arc_worker" {
  depends_on                  = ["aws_instance.arc_master"]

  count                       = "${var.worker_count}"
  ami                         = "${data.aws_ami.amzn2-ami-ecs-hvm.id}"
  instance_type               = "${var.worker_instance_type}"
  key_name                    = "${var.key_name}"
  user_data                   = "${data.template_file.user_data_null.rendered}"
  associate_public_ip_address = true

  tags = {
    Name                      = "${random_uuid.uuid.result}-arc-worker-${count.index}"
    destroy_after             = "${var.destroy_after}"
  }

  provisioner "remote-exec" {
    connection {
      host        = "${self.public_ip}"
      user        = "ec2-user"
      private_key = "${file(var.private_key)}"
    }    

    inline = [
      "docker run -d --net host --hostname $(hostname) -e\"SPARK_LOCAL_IP=$(hostname -i)\" -e \"SPARK_PUBLIC_DNS=$(hostname -i)\" -e \"SPARK_DAEMON_JAVA_OPTS=-XX:+UseG1GC -XX:-UseGCOverheadLimit -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap\" triplai/arc:${var.docker_tag} /bin/bash -c \"rm /opt/spark/conf/log4j.properties;bin/spark-class org.apache.spark.deploy.worker.Worker spark://${aws_instance.arc_master.public_ip}:7077\""
    ]
  }    
}

resource "aws_instance" "arc_driver" {
  depends_on                  = ["aws_instance.arc_master", "aws_instance.arc_worker"]

  ami                         = "${data.aws_ami.amzn2-ami-ecs-hvm.id}"
  instance_type               = "${var.driver_instance_type}"
  key_name                    = "${var.key_name}"
  user_data                   = "${data.template_file.user_data_null.rendered}"
  associate_public_ip_address = true

  tags = {
    Name = "${random_uuid.uuid.result}-arc-driver"
    destroy_after = "${var.destroy_after}"
  }

  provisioner "remote-exec" {
    connection {
      host        = "${self.public_ip}"
      user        = "ec2-user"
      private_key = "${file(var.private_key)}"
    }    

    inline = [
      "docker run --net host --hostname $(hostname) -e\"SPARK_LOCAL_IP=$(hostname -i)\" -e \"SPARK_PUBLIC_DNS=$(hostname -i)\" -e \"ETL_CONF_ENV_ID=${random_uuid.uuid.result}\" -e \"ETL_CONF_ENV=production\" {var.additional_docker_run_commands} triplai/arc:${var.docker_tag} bin/spark-submit --master spark://${aws_instance.arc_master.public_ip}:7077 --class ai.tripl.arc.ARC /opt/spark/jars/arc.jar --etl.config.uri=${var.config_uri}"
    ]
  }  
}