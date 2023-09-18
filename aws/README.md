[![Terraform](https://github.com/autotune/bank-of-anthos/actions/workflows/terraform.yaml/badge.svg)](https://github.com/autotune/bank-of-anthos/actions/workflows/terraform.yaml)


For anyone curious about Crossplane and terraform in AWS, I have a barebones public repo set up that sets up the following and infra to support the following:

RUN THE FOLLOWING FOR EXTERNAL-DNS CONFIG: 

kubectl create secret generic zerosslclusterissuer --from-literal=secret-key=abc123 -ncert-manager 

EKS Cluster for Crossplane and Terraform provider: 1 min 2 max t3.large called "production" 

EKS Cluster created by Crossplane for unofficial Bank of Anthos helm chart (within this repo only): 1 min 2 max t2.medium called "BOA-Prod" 

This relies heavily on the following github repos that were forked over into my own:

[https://github.com/bootlabstech/terraform-aws-fully-loaded-eks-cluster](https://github.com/bootlabstech/terraform-aws-fully-loaded-eks-cluster) (particularly the irsa module) 

[https://github.com/GoogleCloudPlatform/bank-of-anthos](https://github.com/GoogleCloudPlatform/bank-of-anthos) (initial kubernetes manifests that create resources) 

This demo is not meant to test the BOA demo, but rather, Crossplane alongside the Terraform Provider and demonstrate its capabilities. I would highly recommend using kubectx (switch kube cluster context) and kubens (switch default ns) to debug. The following command is also incredibly helpful for debugging the terraform provider should a pod get killed while it is in the middle of a plan/apply:

```
k exec -it $(k get po| awk '{if ($1 ~ "terraform-") print $0}'|awk '{print $1}') sh
```

You can then cd into the tf folder and do a:

```
terraform force-unlock $(terraform init && terraform plan -var-file=crossplane-provider-terraform-0.tfvars 2>&1|grep ID|awk '{print $4}') 
``` 

In my experience this has, so far, not resulted in any loss of state or resources. You can view terraform depencies that have been generated at: 

[https://github.com/autotune/bank-of-anthos/blob/main/aws/terraform.md](https://github.com/autotune/bank-of-anthos/blob/main/aws/terraform.md)

This uses Azure DevOps pipeline at ../azure-pipelines.yml, you can see the vars that get passed in as follows, some are not required like ZeroSSL if you don't care about certs and set an empty string as its value, but would recommend including for your own purposes:

```
-var="rds_bsee_password"=$(RDS_BSEE_PASSWORD) -var="github_user"=$(GITHUB_USER) -var="github_pat"=$(GITHUB_PAT) -var="zerossl_email"=$(ZEROSSL_EMAIL) -var="zerossl_eab_key_id"=$(ZEROSSL_EAB_KEY_ID) -var="zerossl_eab_hmac_key"=$(ZEROSSL_EAB_HMAC_KEY) -var="argocd_oidc_client_id"=$(ARGOCD_OIDC_CLIENT_ID) -var="argocd_oidc_client_secret"=$(ARGOCD_OIDC_CLIENT_SECRET) -var="externaldns_secret_key"=$(EXTERNALDNS_SECRET_KEY)
```

The end result of this demonstration is infrastructure as code that reduces infra drift by ensuring resources are continuously reconciled and kept up to date. If someone goes in and changes something manually that is managed by Crossplane, the change gets automatically reverted. Bank of Anthos demo gets installed and becomes available via svc load balancer, where you can then do some manual chaos testing yourself and see what happens. 

 
