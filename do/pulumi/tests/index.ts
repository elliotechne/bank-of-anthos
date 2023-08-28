import * as digitalocean from "@pulumi/digitalocean";
import * as kubernetes from "@pulumi/kubernetes";
import * as policy from "@pulumi/policy";
import * as pulumi from "@pulumi/pulumi";

const stackPolicy: policy.StackValidationPolicy = {
    name: "eks-test",
    description: "EKS integration tests.",
    enforcementLevel: "mandatory",
    validateStack: async (args, reportViolation) => {
        const clusterResource = args.resources.find(r => r.isType(digitalocean.KubernetesCluster));
        const cluster = clusterResource && clusterResource.asType(digitalOcean.KubernetesCluster);
        if (!cluster) {
            reportViolation("EKS Cluster not found");
            return;
        }
    }
}

const tests = new policy.PolicyPack("tests-pack", {
    policies: [stackPolicy],
});
