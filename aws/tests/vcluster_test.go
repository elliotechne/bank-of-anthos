package test

import (
    "testing"
    "path/filepath"
    "github.com/gruntwork-io/terratest/modules/k8s"
)

func TestVClusterDeployment(t *testing.T) {
    // Path to the Kubernetes resource config we will test
    kubeResourcePath, _ := filepath.Abs("vcluster.yaml")

    // Setup the kubectl config and context. Here we choose to use the current context as
    // defined by the kubeconfig file.
    options := k8s.NewKubectlOptions("", "", "vcluster")

    // At the end of the test, run `kubectl delete` to clean up any resources that were created.
    defer k8s.KubectlDelete(t, options, kubeResourcePath)

    // Run `kubectl apply` to deploy. Fail the test if there are any errors.
    k8s.KubectlApply(t, options, kubeResourcePath)

    // Verify the service is available and get the URL for it.
    k8s.WaitUntilServiceAvailable(t, options, "vcluster", 30, 5)
}

