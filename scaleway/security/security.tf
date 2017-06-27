resource "scaleway_security_group" "exposed-kubernetes-ruleset" {
   name = "my-exposed-kubernetes-ruleset"
   description = "Required ruleset for running a Kubernetes API Server that is accessible from the outside world."
}

resource "scaleway_security_group_rule" "allow-ingress-kube-apiserver" {
   security_group = "${scaleway_security_group.exposed-kubernetes-ruleset.id}"

   action = "accept"
   direction = "inbound"
   ip_range = "0.0.0.0/0"
   protocol = "TCP"
   port = 6443
}

resource "scaleway_security_group_rule" "http_accept" {
   security_group = "${scaleway_security_group.exposed-kubernetes-ruleset.id}"

   action = "accept"
   direction = "inbound"
   ip_range = "0.0.0.0/0"
   protocol = "TCP"
   port = 80
}

resource "scaleway_security_group_rule" "https_accept" {
   security_group = "${scaleway_security_group.exposed-kubernetes-ruleset.id}"

   action = "accept"
   direction = "inbound"
   ip_range = "0.0.0.0/0"
   protocol = "TCP"
   port = 443
}

output "group_id" {
    value = "${scaleway_security_group.exposed-kubernetes-ruleset.id}"
}