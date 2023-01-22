terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}

provider "linode" {
  token       = var.token
  api_version = "v4beta"
}

# linode server
resource "linode_instance" "sudoku_resource_instance" {
  label           = "sudoku_instance_label"
  image           = "linode/ubuntu20.04"
  region          = "eu-central"
  type            = "g6-nanode-1"
  root_pass       = var.root_pass
  authorized_keys = [var.ssh_key]

  provisioner "local-exec" {
    command = "bash build-images.sh ${var.sudoku_be_repo} ${var.sudoku_fe_repo}"
  }

  provisioner "file" {
    source      = "${var.sudoku_cert_loc}"
    destination = "/root"
    connection {
      type     = "ssh"
      host     = self.ip_address
      user     = "root"
      password = var.root_pass
    }
  }
  provisioner "file" {
    source      = "reverse-proxy"
    destination = "/root"
    connection {
      type     = "ssh"
      host     = self.ip_address
      user     = "root"
      password = var.root_pass
    }
  }
  provisioner "file" {
    source      = "${var.sudoku_be_repo}/sudoku_solver_img.tar.gz"
    destination = "/root/sudoku_solver_img.tar.gz"
    connection {
      type     = "ssh"
      host     = self.ip_address
      user     = "root"
      password = var.root_pass
    }
  }
  provisioner "file" {
    source      = "${var.sudoku_fe_repo}/sudoku_solver_fe_img.tar.gz"
    destination = "/root/sudoku_solver_fe_img.tar.gz"
    connection {
      type     = "ssh"
      host     = self.ip_address
      user     = "root"
      password = var.root_pass
    }
  }

  provisioner "remote-exec" {
    inline = [
      # Setup and install docker + nginx
      "apt-get update -y",
      "apt-get install -y docker.io",
      "wget http://nginx.org/keys/nginx_signing.key",
      "apt-key add nginx_signing.key",
      "rm nginx_signing.key",
      "echo deb [arch=amd64] http://nginx.org/packages/mainline/ubuntu/ $(lsb_release -cs) nginx >> /etc/apt/sources.list.d/nginx.list",
      "echo deb-src http://nginx.org/packages/mainline/ubuntu/ $(lsb_release -cs) nginx >> /etc/apt/sources.list.d/nginx.list",
      "apt update",
      "apt install nginx -y",

      # Run docekrized apps
      "docker network create -d bridge sudoku_solver_net.local",
      "docker load -i sudoku_solver_img.tar.gz",
      "docker run --name=sudoku_solver_fastapi --network=sudoku_solver_net.local --rm=true -p 8001:8000 -itd sudoku_solver_img:v1.0",
      "docker load -i sudoku_solver_fe_img.tar.gz",
      "docker run --name=sudoku_solver_react_fe --network=sudoku_solver_net.local --rm=true -p 81:80 -itd sudoku_solver_fe_img:v1.0-prod",

      # Setup nginx reverse-proxy
      "systemctl enable nginx",
      "systemctl start nginx",
      "mv /root/reverse-proxy/* /etc/nginx/conf.d/.",
      "mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.disabled",
      "nginx -t",
      "nginx -s reload",
    ]

    connection {
      type     = "ssh"
      host     = self.ip_address
      user     = "root"
      password = var.root_pass
    }
  }
}

# domain
resource "linode_domain" "sudoku_domain" {
  domain    = "ambardas.nl"
  soa_email = "ambardeepdas@gmail.com"
  type      = "master"
}
# domain record
resource "linode_domain_record" "sudoku_domain_record" {
  domain_id   = linode_domain.sudoku_domain.id
  name        = "ambardas.nl"
  record_type = "A"
  target      = linode_instance.sudoku_resource_instance.ip_address
  ttl_sec     = 300
}


# firewall
resource "linode_firewall" "sudoku_firewall" {
  label = "sudoku_firewall_label"

  inbound {
    label    = "allow-http"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "443, 80, 8000"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["ff00::/8"]
  }
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  linodes = [linode_instance.sudoku_resource_instance.id]

}

# variables
variable "token" {}
variable "ssh_key" {}
variable "root_pass" {}
variable "sudoku_be_repo" {}
variable "sudoku_fe_repo" {}
variable "sudoku_cert_loc" {}
