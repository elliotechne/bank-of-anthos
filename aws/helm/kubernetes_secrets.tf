resource "kubernetes_secret" "zerossl_eab_hmac_key" {
  provider   = kubernetes
  metadata {
    name      = "zerossl-eab-hmac-key"
    namespace = "cert-manager"
  }

  data = {
    secret = var.zerossl_eab_hmac_key
  }

  type = "kubernetes.io/opaque"
}

resource "kubernetes_secret" "zerossl_eab_key_id" {
  provider   = kubernetes
  metadata {
    name      = "zerossl-eab-hmac-key-id"
    namespace = "cert-manager"
  }

  data = {
    secret = var.zerossl_eab_key_id
  }

  type = "kubernetes.io/opaque"
}

resource "kubernetes_secret" "wayofthesys-tls" {
  provider   = kubernetes
  depends_on = [module.external_dns]
  metadata {
    name      = "${replace(var.domain_name[0], ".", "-")}-tls"
    namespace = "istio-system"
  }
  type = "tls"
  data = {
    "tls.crt" = tls_locally_signed_cert.cert.cert_pem
    "tls.key" = tls_private_key.key.private_key_pem
  }

  lifecycle {
    ignore_changes = [
      data,
      metadata
    ]
  }
}

resource "kubernetes_secret" "terraform-vars" {
  provider   = kubernetes
  depends_on = [kubernetes_namespace.crossplane-system]
  metadata {
    name      = "terraform"
    namespace = "crossplane-system"
  }
  type = "opaque"
  data = {
    "production.tfvars" = <<EOT
region = "${var.crossplane_region}" 
eks_cluster_name = "${var.crossplane_eks_cluster_name}-Prod"
  EOT
  }
}

resource "kubernetes_secret" "external-dns" {
  provider   = kubernetes
  depends_on = [module.external_dns]
  metadata {
    name      = "externaldns"
    namespace = "cert-manager"
  }
  type = "opaque"
  data = {
    secret-key = var.externaldns_secret_key
  }
}

resource "kubernetes_secret" "git-credentials" {
  provider   = kubernetes
  depends_on = [kubernetes_namespace.crossplane-system]
  metadata {
    name      = "git-credentials"
    namespace = "crossplane-system"
  }
  type = "generic"
  data = {
    ".git-credentials" = "https://${var.github_user}:${var.github_pat}"
  }
}
