# AWS Auth Operator

This is a custom K8s operator which helps manage updates to the "aws-auth" config map in AWS EKS.


## Quick Start
(TODO : Helm chart doc)
- Execute `kubectl apply -f samples/manifests.yaml`. This would deploy the following:
  - namespace
  - crd
  - service account
  - rbac resources
  - deployment
- Run `kubectl get po -n aws-auth-operator-system` , Should see the workload running
    
    ```
    NAME                                                     READY   STATUS    RESTARTS   AGE
    aws-auth-controller-controller-manager-55858f98b-ctfrs   2/2     Running   0          54m

    ```

- Once the controller starts running , execute `kubectl apply -f samples/sample.yaml` . This deploys the `EksAuthMap` custom resource. `[YOUR_AWS_ACCOUNT]` should be subsitituted with the proper AWS Account.
- Check the logs of the controller and should see the reconcile operation

  ```
    2022/04/12 07:47:32 RECONCILING AWS AUTH CONTROLLER
    2022/04/12 07:47:32 false
    2022/04/12 07:47:32 RECONCILER: FETCHING EXISTING aws-auth CONFIGMAP
    2022/04/12 07:47:32 RECONCILER: Unmarshalling aws-auth CONFIGMAP
    2022/04/12 07:47:32 [{arn:aws:iam::8491xxxx47351:role/sre-role sre-cluster-admin role [ADMIN] []} {arn:aws:iam::8491xxxx47351:role/hsre-role hsre-cluster-role role [READONLY] []} {arn:aws:iam::849180847351:role/cd-jenkins-role cd-jenkins role [ADMIN] []} {arn:aws:iam::8491xxxx47351:role/app-dev app-dev role [NSADMIN READONLY] [web app]} {arn:aws:iam::8491xxxx47351:role/app-architects architects role [WRITE group2] []} {arn:aws:iam::8491xxxx47351:user/ops-user ops-user user [ADMIN] []} {arn:aws:iam::8491xxxx47351:user/ops-user ops-user user [my-custom-group group2] []}]
    2022/04/12 07:47:32 RECONCILER: ITERATING THROUGH ALL THE RBAC CONFIGS
    2022/04/12 07:47:32 ARN: arn:aws:iam::8491xxxx47351:role/sre-role ~ UserName: sre-cluster-admin
    2022/04/12 07:47:32 RECONCILER: VALIDATED GROUPS FROM GIVEN LIST
    2022/04/12 07:47:32 RECONCILER: Adding provided roles to mapRoles
    2022/04/12 07:47:32 ARN: arn:aws:iam::8491xxxx47351:role/hsre-role ~ UserName: hsre-cluster-role
    2022/04/12 07:47:32 RECONCILER: VALIDATED GROUPS FROM GIVEN LIST
    2022/04/12 07:47:32 createClusterRole: Creating the ClusterRole:application-ro-cluster-role
    2022/04/12 07:47:32 clusterroles.rbac.authorization.k8s.io "application-ro-cluster-role" already exists
    2022/04/12 07:47:32 createClusterRoleBinding: Creating the clusterrolebinding:application-ro-cluster-role-binding
    2022/04/12 07:47:32 clusterroles.rbac.authorization.k8s.io "application-ro-cluster-role" already exists
    2022/04/12 07:47:32 RECONCILER: Adding provided roles to mapRoles
    2022/04/12 07:47:32 ARN: arn:aws:iam::8491xxxx47351:role/cd-jenkins-role ~ UserName: cd-jenkins
    2022/04/12 07:47:32 RECONCILER: VALIDATED GROUPS FROM GIVEN LIST
    2022/04/12 07:47:32 RECONCILER: Adding provided roles to mapRoles
    2022/04/12 07:47:32 ARN: arn:aws:iam::8491xxxx47351:role/app-dev ~ UserName: app-dev
    2022/04/12 07:47:32 RECONCILER: VALIDATED GROUPS FROM GIVEN LIST
    2022/04/12 07:47:32 Reconcile: Creating Provided Namespaces
    2022/04/12 07:47:32 createNamespace: Creating the namespace:web
    2022/04/12 07:47:32 namespaces "web" already exists
    2022/04/12 07:47:32 createRole: Creating the Role:application-adm-role-for-ns-web
    2022/04/12 07:47:32 roles.rbac.authorization.k8s.io "application-adm-role-for-ns-web" already exists
    2022/04/12 07:47:32 createrRoleBinding: Creating the rolebinding:application-adm-role-for-ns-web-binding
    2022/04/12 07:47:32 rolebindings.rbac.authorization.k8s.io "application-adm-role-for-ns-web-binding" already exists
    2022/04/12 07:47:32 createNamespace: Creating the namespace:app
    2022/04/12 07:47:32 namespaces "app" already exists
    2022/04/12 07:47:32 createRole: Creating the Role:application-adm-role-for-ns-app
    2022/04/12 07:47:32 roles.rbac.authorization.k8s.io "application-adm-role-for-ns-app" already exists
    2022/04/12 07:47:32 createrRoleBinding: Creating the rolebinding:application-adm-role-for-ns-app-binding
    2022/04/12 07:47:32 rolebindings.rbac.authorization.k8s.io "application-adm-role-for-ns-app-binding" already exists
    2022/04/12 07:47:32 createRole: Creating the Role:application-adm-role-for-ns-default
    2022/04/12 07:47:32 roles.rbac.authorization.k8s.io "application-adm-role-for-ns-default" already exists
    2022/04/12 07:47:32 createrRoleBinding: Creating the rolebinding:application-adm-role-for-ns-default-binding
    2022/04/12 07:47:32 rolebindings.rbac.authorization.k8s.io "application-adm-role-for-ns-default-binding" already exists
    2022/04/12 07:47:32 RECONCILER: VALIDATED GROUPS FROM GIVEN LIST
    2022/04/12 07:47:32 createClusterRole: Creating the ClusterRole:application-ro-cluster-role
    2022/04/12 07:47:32 clusterroles.rbac.authorization.k8s.io "application-ro-cluster-role" already exists
    2022/04/12 07:47:32 createClusterRoleBinding: Creating the clusterrolebinding:application-ro-cluster-role-binding
    2022/04/12 07:47:32 clusterroles.rbac.authorization.k8s.io "application-ro-cluster-role" already exists
    2022/04/12 07:47:32 RECONCILER: Adding provided roles to mapRoles
    2022/04/12 07:47:32 ARN: arn:aws:iam::8491xxxx47351:role/app-architects ~ UserName: architects
    2022/04/12 07:47:32 RECONCILER: VALIDATED GROUPS FROM GIVEN LIST
    2022/04/12 07:47:32 createClusterRoleBinding: Creating the clusterrolebinding:application-edit-cluster-role-binding
    2022/04/12 07:47:32 <nil>
    2022/04/12 07:47:32 RECONCILER: VALIDATED GROUPS FROM GIVEN LIST
    2022/04/12 07:47:32 RECONCILER: Adding provided roles to mapRoles
    2022/04/12 07:47:32 ARN: arn:aws:iam::8491xxxx47351:user/ops-user ~ UserName: ops-user
    2022/04/12 07:47:32 RECONCILER: VALIDATED GROUPS FROM GIVEN LIST
    2022/04/12 07:47:32 RECONCILER: Adding provided users to mapUsers
    2022/04/12 07:47:32 ARN: arn:aws:iam::8491xxxx47351:user/ops-user ~ UserName: ops-user
    2022/04/12 07:47:32 RECONCILER: VALIDATED GROUPS FROM GIVEN LIST
    2022/04/12 07:47:32 RECONCILER: VALIDATED GROUPS FROM GIVEN LIST
    2022/04/12 07:47:32 RECONCILER: Adding provided users to mapUsers
    2022/04/12 07:47:32 RECONCILER: Marshalling back mapRoles and mapUsers
    2022/04/12 07:47:32 RECONCILER: Updating aws-auth Config Map

  ```
- Check the configMap if its updated - `kubectl edit cm aws-auth -n kube-system`  

    
## EksAuthMap Custom Resource

This CR should be submitted for the Controller to reconcile.

| Schema | Description |
| ---- | --- |
| apiVersion | operators.apphosting.com/v1 |
| kind | EksRbac |
| spec.config | List of roles/users which needs additional RBAC |
| spec.config[0].arn | ARN of the role/user |
| spec.config[0].username | username to be assosciated with the config |
| spec.config[0].groups | List of groups.Supported Groups - `ADMIN`, `NODE`, `READONLY`, `NSADMIN` ,`WRITE`|
| spec.config[0].namespaces | List of namespaces which requires admin privileges |
| spec.config[0].type | Supported values : `role` , `user` |

### More about `groups`

`ADMIN` - This group essentially maps to `system:masters` which gives the complete administrative access to the cluster.

`NODE` - This group would map to `system:nodes` and `system:bootstrappers`

`READONLY` - This group gives a complete read access to the entire cluster. On giving this group, readonly ClusterRole and assosciated ClusterRoleBindings gets created.

`NSADMIN` - Users might just require administrative privilege on specific namespaces alone.  
You need to supply a list of namespaces where this access is needed. 
If none provided, then it would assume that access is only needed for `default` namespace. Additionally, this creates the namespaces provided, and also the assosciated Roles and Role Bindings for each namespace.

`WRITE` - This will allow users/roles to have the edit access on the K8s cluster resources.

> You can provide your own custom groups if the above does not meet your requirements

## Developer Notes:

- Clone the repo locally
- Run the command - `make docker-build docker-push IMG=<YOUR_REPO>/aws-auth-operator:<YOUR_TAG>`
- This would build and push the container image to the mentioned repository
- To deploy , execute - `make deploy IMG=<YOUR_REPO>/aws-auth-operator:<YOUR_TAG>`
- This would deploy the operator to the cluster-context set at ~/.kube/config.

If you need to see the manifests that are being deployed , run:

`make gentest IMG=<YOUR_REPO>/aws-auth-operator:<YOUR_TAG>`
   
#### Notes:
- Operator matches the given inputs with the already configured configMap and performs the necessary "inserts" or "updates".
- If no change is determined, no updates are made to the configMap.
- Currently the operator does not have the capability to delete an entry from the configMap.