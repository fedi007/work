resource "aws_launch_template" "eks" {
  name = "eks-launch-template-assesment"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20
      encrypted             = true
      delete_on_termination = true
    }
  }

  credit_specification {
    cpu_credits = "standard"
  }
  cpu_options {
    core_count       = 1
    threads_per_core = 1
  }

  #  capacity_reservation_specification {
  #    capacity_reservation_preference = "open"
  #  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.eks_cluster_name}-node"
    }
  }

}