# We need a bit of special configuration
# for the master node: 
variable "master_prefix" { 
    description = "The Master Subdomain" }

variable "domain" {
    description = "The (Cloudflare Managed) Domain you wish to use"}

variable "redirect_domain_to_master" { }

# Subdomains of the Master have to be redirected to the Master
# because we use it for Ingress.
# CNAME *.<kube-master>.<domain> --> <kube-master>.<domain>
resource "cloudflare_record" "master-ingress" {
    domain = "${var.domain}"
    name   = "*.${var.master_prefix}"
    value  = "${var.master_prefix}.${var.domain}"
    type   = "CNAME"

    proxied = false
}

# The Main Domain needs a cname to the master node
# (this is conditional)
# CNAME <kube-master>.<domain> --> <domain>
resource "cloudflare_record" "master" {
    domain = "${var.domain}"
    name   = "${var.domain}"
    value  = "${var.master_prefix}.${var.domain}"
    type   = "CNAME"

    proxied = false

    count = "${var.redirect_domain_to_master}"
}
