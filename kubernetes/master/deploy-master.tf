variable "host" {}
variable "ssh_key" {}
variable "kube_token" {}
variable "kube_apiserver_advertise_ip" {}

resource "null_resource" "deploy-master" {
    connection {
        host = "${var.host}"
        private_key = "${file(var.ssh_key)}"
        user = "root"
        type = "ssh"
    }

    provisioner "remote-exec" {
        inline = [
            "kubeadm init --token ${var.kube_token} --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address ${var.kube_apiserver_advertise_ip}"
        ]
    }
}