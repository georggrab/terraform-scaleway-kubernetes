Bootstrap a kubeadm Kubernetes Cluster on Scaleway!
===========================================

This repository contains terraform scripts to bootstrap a Kubernetes Cluster on Scaleway with as little configuration as possible. All you're going to need:

* Scaleway Account
* Domain connected to Cloudflare

With Scaleway, you'll be able to get a (3-Node) Kubernetes Cluster running for less than 10€ a month, which is the cheapest I've seen from any cloud provider.

# Features

These script will allow you to:

* Bootstrap a working Kubernetes Cluster using Kubeadm
* Create DNS entries on Cloudflare for your masters and nodes (useful for development)
* Once Bootstrapped, you'll have the ability to scale the amount of Cluster Nodes dynamically.

## Opinions

The Cluster we'll create with this config is a bit opinionated:

Software we'll use:

* Ubuntu Xenial as the OS, because of its excellent Kubernetes support
* Flannel for Pod Networking, though you can disable the installation of this and install your own

About the Cluster we'll create: *(not yet implemented, coming soon)*

* The Master Node will also be the Cluster Ingress (handle incoming traffic)
* These `kube-system` services will be installed: 
  * [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) for easy monitoring
  * [nginx-ingress-controller](https://github.com/kubernetes/ingress/tree/master/controllers/nginx) for handling incoming traffic
  * [kube-lego](https://github.com/jetstack/kube-lego) for provisioning Letsencrypt certificates dynamically

Of course, you can just skip the cluster creation step by setting `install_kubernetes_services` to false in `terraform.tfvars` for full control. If you do that, you'll basically be at step 3 of the [official kubeadm tutorial](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#pod-network), except the _joining your nodes_ part, which has already been done for you. Once you installed the Pod Network of your choice, your cluster will be ready

## Caveats

This is in heavy development, the following things are to consider for now before using this:

* Kubernetes Nodes get public ip addresses and DNS Entries, this is a security concern and will be optional in the future. Only use this Cluster for development until then.
* only x86_64 Machines are supported currently, I'll begin working on ARM support soon
* No storage solution yet

# Setup

These are the required Variables you'll have to change in `terraform.tfvars`:

```bash
# Your Scaleway Access Key
scaleway_organization = "<access key here>"

# A Scaleway token associated with your account
scaleway_token = "<some token here>"

# Set this to the location of the SSH Key that is associated
# with your Scaleway account.
ssh_key = "/path/to/id_rsa"

# Fill in your Cloudflare Auth Information here
cloudflare_token = "<your cloudflare token>"
cloudflare_email = "<your cloudflare email>"
domain = "<your cloudflare managed domain>"
```

After you've changed these settings, generate a Token which `kubeadm` will use to authenticate nodes to the cluster:

```bash
$ ./scripts/generate-kubeadm-token.sh
```

Then, do `terraform plan` and `terraform apply` and hope for the best :D
