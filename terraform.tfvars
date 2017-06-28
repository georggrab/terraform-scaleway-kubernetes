##########################
### REQUIRED SETTINGS ####
##########################

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

# The token to use for Cluster Bootstrapping
# Keep this secret, as this can be used to
# join nodes to your cluster later on. Change this
# to a lowercase alpha numeric string looking like
# "<6 characters>.<16 characters>" or execute
# scripts/generate-kubeadm-token.sh, which will replace
# this placeholder by a random string matching the requirements.
kube_token = ${GENERATED_KUBEADM_TOKEN}

###################################
### OPTIONAL SETTINGS #############
################################### 

# How many Kubernetes Nodes should be created.
kubernetes_node_count = 2

# The Domain Prefix of the master
master_prefix = "km-"

# The Domain Prefix of the nodes
node_prefix = "kn-"

# If this is true, a CNAME record from your domain to the
# Kubernetes Master node will be created. Do this if you
# want your cluster to be accessible directly from your domain.
# This is useful if you use your Master Node for Ingress.
redirect_domain_to_master = true

# So far only x86_64 Machines are supported
# ARM Support is coming up.
machine_type = "VC1S"

# Don't use this until terraform has its scaleway provider issues resoled.
attach_volumes_to_nodes = false

# AFAIK, only 50GB increments are supported by Scaleway Volumes
volume_size = 50