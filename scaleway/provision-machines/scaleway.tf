data "scaleway_image" "ubuntu" {
    architecture = "x86_64"
    name = "Ubuntu Xenial"
}

resource "scaleway_server" "kube-node" {
   name = "${var.name}-${count.index}"

   image = "${data.scaleway_image.ubuntu.id}"
   
   # 2 X86_64 Cores, 2 GB Memory, 2,99€/Month
   type = "VC1S"

   security_group = "${var.security_group_id}"

   count = "${var.count}"

   enable_ipv6 = true
   dynamic_ip_required = true

   tags = ["${count.index}", "tf-managed"]

   connection {
       type = "ssh"
       user = "root"
       private_key = "${file(var.ssh_key)}"
   }

   provisioner "remote-exec" {
        scripts = [
            "scripts/install-kubeadm.sh"
        ]
   }
}

output "vm_ips" {
    value = ["${scaleway_server.kube-node.*.public_ip}"]
}

#output "vm_indices" {
#    value = ["${scaleway_server.kube-node.*.tags.0}"]
#}