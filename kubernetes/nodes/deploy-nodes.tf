variable "hosts" { type = "list" }
variable "count" {}
variable "ssh_key" {}
variable "kube_master_ip" {}
variable "kube_token" {}

variable "depends_on" {}

resource "null_resource" "deploy-nodes" {
    count = "${var.count}"

    connection {
        host = "${element(var.hosts, count.index)}"
        private_key = "${file(var.ssh_key)}"
        user = "root"
        type = "ssh"
    }

    provisioner "remote-exec" {
        inline = [
            "kubeadm join --token ${var.kube_token} ${var.kube_master_ip}:6443"
        ]
    }
}