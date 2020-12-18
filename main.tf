provider "aws" {
region = "us-east-1"
}

provider "google" {
  project     = "unilever-poc"
  region      = "us-central1"
  #credentials = file ("gcp-ulpoc.json")
  zone = "us-east4-a"
}
terraform {
  backend "gcs" {
    bucket  = "ul-poc-terraform"
    prefix  = "terraform/state"
  }
}
# resource "aws_instance" "mohi-vm" {
#   ami = "ami-0885b1f6bd170450c"
#   instance_type = "t2.micro"
#   tags = {
#   Name = "Mohi-instance"
#  }
# }

# output "aws_instance1_id" {
#  value = aws_instance.mohi-vm.id
# }
# output "aws_instance_cpu_count" {
#  value =  aws_instance.mohi-vm.cpu_core_count
# }

resource "google_compute_instance" "mohivm" {
  name         = "mohi-vm"
  machine_type = "f1-micro"
  zone         = "us-east4-a"
  labels = {
    env = "prod",
    creator = "mohi"
  }
  tags = ["env", "terraform"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }


  network_interface {
   subnetwork = "sbnt-ul-poc-01"

    access_config {
      // Ephemeral IP
    }
  }
}

output "output_vm" {
  value = google_compute_instance.mohivm.network_interface[0].access_config.nat_ip
}

