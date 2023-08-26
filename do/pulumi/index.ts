import * as pulumi from "@pulumi/pulumi"; 
import * as digitalocean from "@pulumi/digitalocean";
import * as kubernetes from "@pulumi/kubernetes"; 

const cluster = new digitalocean.KubernetesCluster("boa", {
    region: digitalocean.Region.SFO2,
    version: "latest",
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

export const kubeconfig = cluster.kubeConfigs[0].rawConfig;
