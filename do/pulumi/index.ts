import * as pulumi from "@pulumi/pulumi"; 
import * as digitalocean from "@pulumi/digitalocean";
import * as kubernetes from "@pulumi/kubernetes"; 

const cluster = new digitalocean.KubernetesCluster("boa", {
    region: digitalocean.Region.SFO2,
    version: "1.27.4-do.0",
    nodePool: {
        name: "worker01",
        size: digitalocean.DropletSlug.DropletS2VCPU2GB,
        nodeCount: 3,
    },
});

const config = new pulumi.Config();
const k8sNamespace = config.get("k8sNamespace") || "default";
const appLabels = {
  app: "nginx-ingress",
}

// Create NS
const ingressNs = new kubernetes.core.v1.Namespace("ingressns", {metadata: {
    labels: appLabels,
    name: k8sNamespace
}});

// Use Helm to install the Nginx ingress controller
const ingressController = new kubernetes.helm.v3.Release("ingresscontroller", {
    chart: "nginx-ingress",
    namespace: ingressNs.metadata.name,
    repositoryOpts: {
        repo: "https://helm.nginx.com/stable",
    },
    skipCrds: true,
    values: {
        controller: {
            enableCustomResources: false,
            appprotect: {
                enable: false,
            },
            appprotectdos: {
                enable: false,
            },
            service: {
                extraLabels: appLabels,
            },
        },
    },
    version: "0.14.1",
});

// Export some values for use elsewhere
export const name = ingressController.name;

export const kubeconfig = cluster.kubeConfigs[0].rawConfig;
