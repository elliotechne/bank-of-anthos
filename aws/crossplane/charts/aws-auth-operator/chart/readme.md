# Helm Chart for `aws-auth-operator`

This helm chart can be used to deploy `aws-auth-operator` in a Kubernetes cluster.

## Installation

This chart bootstraps aws-auth-operator as a Kubernetes controller , using Custom Resource - `EksAuthMap`

### Pre-requisites

With the command helm version, make sure that you have:
- Helm v3 installed

Clone the repo

### Deploying aws-auth-operator

```
cd chart
helm upgrade --install aws-auth-operator -n aws-auth-operator .

``` 

For deploying the Custom Resource refer the [Sample](../samples/sample.yaml)