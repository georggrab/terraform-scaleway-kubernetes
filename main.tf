variable "scaleway_token" {}
variable "scaleway_organization" {}
variable "cloudflare_token" {}
variable "cloudflare_email" {}
variable "kubernetes_node_count" {}
variable "domain" {}
variable "master_prefix" {}
variable "node_prefix" {}
variable "redirect_domain_to_master" {}
variable "ssh_key" {}
variable "kube_token" {}
variable "attach_volumes_to_nodes" {}
variable "volume_size" {}
variable "machine_type" {}

// Machine Configuration

provider "scaleway" {
   token = "${var.scaleway_token}"
   organization = "${var.scaleway_organization}"
   region = "ams1"
}


provider "cloudflare" {
    token = "${var.cloudflare_token}"
    email = "${var.cloudflare_email}"
}

module "scaleway_security" {
    source = "./scaleway/security"
}

module "create-kube-masters" {
    source = "./scaleway/provision-machines"
    name = "kube-master"

    ssh_key = "${var.ssh_key}"

    # There's no way to create a HA Cluster using
    # Kubeadm as of right now, so we'll have the
    # master count hardcoded to 1 for now.
    count = 1

    security_group_id = "${module.scaleway_security.group_id}"

    machine_type = "${var.machine_type}"
}

module "create-kube-nodes" {
    source = "./scaleway/provision-machines"

    name = "kube-node"
    ssh_key = "${var.ssh_key}"
    count = "${var.kubernetes_node_count}"

    security_group_id = "${module.scaleway_security.group_id}"
}

module "create-kube-nodes-data" {
    source = "./scaleway/volume"

    for_servers = "${module.create-kube-nodes.vm_ids}"
    volume_size = "${var.volume_size}"
    enabled = "${var.attach_volumes_to_nodes}"
    count = "${var.kubernetes_node_count}"
}

// DNS Configuration

module "assign-master-hostname" {
    source = "./cloudflare/machine-records"
    domain = "${var.domain}"
    domain_prefix = "${var.master_prefix}"

    ipv4_addresses = "${module.create-kube-masters.vm_ips}"
    count = 1
}

module "master-ingress-records" {
    source = "./cloudflare/master-records"
    domain = "${var.domain}"
    master_prefix = "${var.master_prefix}0"
    redirect_domain_to_master = "${var.redirect_domain_to_master}"
}

module "assign-node-hostname" {
    source = "./cloudflare/machine-records"
    domain = "${var.domain}"
    domain_prefix = "${var.node_prefix}"

    ipv4_addresses = "${module.create-kube-nodes.vm_ips}"
    count = "${var.kubernetes_node_count}"
}

// Kubernetes Configuration

module "deploy-kube-master" {
    source = "./kubernetes/master"
    kube_apiserver_advertise_ip = "${module.create-kube-masters.vm_ips[0]}"

    host = "${module.create-kube-masters.vm_ips[0]}"
    ssh_key = "${var.ssh_key}"
    kube_token = "${var.kube_token}"
}

module "deploy-kube-nodes" {
    source = "./kubernetes/nodes"
    hosts = "${module.create-kube-nodes.vm_ips}"
    ssh_key = "${var.ssh_key}"
    kube_token = "${var.kube_token}"
    kube_master_ip = "${module.create-kube-masters.vm_ips[0]}"
    count = "${var.kubernetes_node_count}"

    depends_on = "${module.assign-node-hostname.hostnames[0]}"
}