# DNS Records that are created for every
# Machine in the Cluster (Master + Nodes)

variable "domain_prefix" {}
variable "ipv4_addresses" { type = "list" }
variable "count" {}
variable "domain" {}


resource "cloudflare_record" "record" {
   name = "${var.domain_prefix}${count.index}"

   domain = "${var.domain}"

   value = "${var.ipv4_addresses[count.index]}"

   type = "A"
   ttl = 120

   proxied = false

   count = "${var.count}"
}

output "hostnames" {
    value = ["${cloudflare_record.record.*.hostname}"]
}