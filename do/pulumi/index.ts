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

export const kubeconfig = cluster.kubeConfigs[0].rawConfig;
