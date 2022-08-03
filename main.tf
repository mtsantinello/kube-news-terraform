terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token 
  #Token gerado na conta do DigitalOcean, na parte de API, que associa a conta ao provider do Terraform.
  }

resource "digitalocean_kubernetes_cluster" "k8s_cursodevops" {
  name   = var.k8s_name
  region = var.region
  version = "1.23.9-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 1

  }
}

resource "digitalocean_kubernetes_node_pool" "node_premium" {
  cluster_id = digitalocean_kubernetes_cluster.k8s_cursodevops.id

  name       = "premium"
  size       = "s-2vcpu-2gb"
  node_count = 1
 
}

variable "do_token" {}
variable "k8s_name" {}
variable "region" {}

output "kube_endpoint" {
    value= digitalocean_kubernetes_cluster.k8s_cursodevops.endpoint
}

resource "local_file" "kube_config" {
    content  = digitalocean_kubernetes_cluster.k8s_cursodevops.kube_config.0.raw_config
    filename = "kube_config.yaml"
}
#cria o arquivo que dá acesso ao cluster kubernetes, com todos os dados e credenciais necessários
#kubectl get nodes --kubeconfig kube_config.yaml