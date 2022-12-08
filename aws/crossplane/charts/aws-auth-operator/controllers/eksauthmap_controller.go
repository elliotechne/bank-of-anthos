/*
Copyright 2022.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package controllers

import (
	"context"
	"fmt"
	"log"
	"reflect"

	yaml "gopkg.in/yaml.v2"
	corev1 "k8s.io/api/core/v1"
	v1 "k8s.io/api/rbac/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	clog "sigs.k8s.io/controller-runtime/pkg/log"

	eksauthv1 "aws-auth-operator/api/v1"
	"aws-auth-operator/controllers/model"
)

const (
	AUTH_CM_NAME = "aws-auth"
	ROLE         = "role"
	USER         = "user"
	// Allowed groups from CR
	CLUSTER_ADMIN = "ADMIN"
	VIEW_ONLY     = "READONLY"
	EC2_NODE      = "NODE"
	NS_ADMIN      = "NSADMIN"
	WRITE_ONLY    = "WRITE"

	CLUSTER_EKS_ADMIN_GROUP             = "system:masters"
	EC2_EKS_BOOSTRAPPERS_GROUP          = "system:bootstrappers"
	EC2_EKS_NODES_GROUP                 = "system:nodes"
	APPHOSTING_CONSUMER_ROLE_PREFIX     = "application-adm-role-for-ns"
	APPHOSTING_CONSUMER_READONLY_ROLE   = "application-ro-cluster-role"
	APPHOSTING_CONSUMER_EDIT_ROLE       = "application-edit-cluster-role"
	APPHOSTING_SYSTEM_EDIT_CLUSTER_ROLE = "system:aggregate-to-edit"
)

// EksAuthMapReconciler reconciles a EksAuthMap object
type EksAuthMapReconciler struct {
	client.Client
	Scheme *runtime.Scheme
}

func IsCustomGroup(g string) bool {
	switch g {
	case
		CLUSTER_ADMIN,
		VIEW_ONLY,
		EC2_NODE,
		WRITE_ONLY,
		NS_ADMIN:
		return false
	}
	return true
}
func IsValidType(g string) bool {
	switch g {
	case
		ROLE,
		USER:
		return true
	}
	return false
}
func (r *EksAuthMapReconciler) createNamespace(Ctx context.Context, name string, obj string) error {
	log.Print(fmt.Sprintf("createNamespace: Creating the namespace:" + name))
	ns := &corev1.Namespace{
		ObjectMeta: metav1.ObjectMeta{
			Name: name,
			Labels: map[string]string{
				"owner": obj,
			},
		},
	}
	err := r.Create(Ctx, ns)
	return err
}

//Read only clusterrole
func (r *EksAuthMapReconciler) createClusterRole(Ctx context.Context, name string) error {
	log.Print(fmt.Sprintf("createClusterRole: Creating the ClusterRole:" + name))
	cr := &v1.ClusterRole{
		ObjectMeta: metav1.ObjectMeta{
			Name: name,
		},
		Rules: []v1.PolicyRule{
			{
				Verbs: []string{
					"get",
					"list",
					"watch",
				},
				APIGroups: []string{
					"*",
				},
				Resources: []string{
					"*",
				},
			},
		},
	}

	err := r.Create(Ctx, cr)
	return err
}

func (r *EksAuthMapReconciler) createClusterRoleBinding(Ctx context.Context, name string, subject string, role string) error {
	log.Print(fmt.Sprintf("createClusterRoleBinding: Creating the clusterrolebinding:" + name))
	crb := &v1.ClusterRoleBinding{
		ObjectMeta: metav1.ObjectMeta{
			Name: name,
		},
		Subjects: []v1.Subject{
			{
				Kind:     "Group",
				Name:     subject,
				APIGroup: "rbac.authorization.k8s.io",
			},
		},
		RoleRef: v1.RoleRef{
			APIGroup: "rbac.authorization.k8s.io",
			Kind:     "ClusterRole",
			Name:     role,
		},
	}
	errCrb := r.Create(Ctx, crb)
	return errCrb
}

//Creating Namespace admin role
func (r *EksAuthMapReconciler) createRole(Ctx context.Context, name string, ns string) error {
	log.Print(fmt.Sprintf("createRole: Creating the Role:" + name))
	ro := &v1.Role{
		ObjectMeta: metav1.ObjectMeta{
			Name:      name,
			Namespace: ns,
		},
		Rules: []v1.PolicyRule{
			{
				Verbs: []string{
					"*",
				},
				APIGroups: []string{
					"*",
				},
				Resources: []string{
					"*",
				},
			},
		},
	}

	err := r.Create(Ctx, ro)
	return err
}
func (r *EksAuthMapReconciler) createRoleBinding(Ctx context.Context, ns string, name string, subject string, role string) error {
	log.Print(fmt.Sprintf("createrRoleBinding: Creating the rolebinding:" + name))
	rb := &v1.RoleBinding{
		ObjectMeta: metav1.ObjectMeta{
			Name:      name,
			Namespace: ns,
		},
		Subjects: []v1.Subject{
			{
				Kind:     "Group",
				Name:     subject,
				APIGroup: "rbac.authorization.k8s.io",
			},
		},
		RoleRef: v1.RoleRef{
			APIGroup: "rbac.authorization.k8s.io",
			Kind:     "Role",
			Name:     role,
		},
	}
	errrb := r.Create(Ctx, rb)
	return errrb
}

//+kubebuilder:rbac:groups=eksauth.operators.com,resources=eksauthmaps,verbs=get;list;watch;create;update;patch;delete
//+kubebuilder:rbac:groups=eksauth.operators.com,resources=eksauthmaps/status,verbs=get;update;patch
//+kubebuilder:rbac:groups=eksauth.operators.com,resources=eksauthmaps/finalizers,verbs=update
//+kubebuilder:rbac:groups="",resources=configmaps,verbs=get;list;watch;create;update;patch
//+kubebuilder:rbac:groups="",resources=namespaces,verbs=get;list;watch;create;update;patch
//+kubebuilder:rbac:groups="rbac.authorization.k8s.io",resources=clusterrolebindings,verbs=*;
//+kubebuilder:rbac:groups="rbac.authorization.k8s.io",resources=clusterroles,verbs=*;
//+kubebuilder:rbac:groups="rbac.authorization.k8s.io",resources=rolebindings,verbs=*;
//+kubebuilder:rbac:groups="rbac.authorization.k8s.io",resources=roles,verbs=*;
// Reconcile is part of the main kubernetes reconciliation loop which aims to
// move the current state of the cluster closer to the desired state.
// TODO(user): Modify the Reconcile function to compare the state specified by
// the EksAuthMap object against the actual cluster state, and then
// perform operations to make the cluster state reflect the state specified by
// the user.
//
// For more details, check Reconcile and its Result here:
// - https://pkg.go.dev/sigs.k8s.io/controller-runtime@v0.11.0/pkg/reconcile
func (r *EksAuthMapReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
	log.Print("RECONCILING AWS AUTH CONTROLLER")
	_ = clog.FromContext(ctx)
	var rbacDef eksauthv1.EksAuthMap
	var authData model.AwsAuthData
	var grps []string
	var authRole []*model.RolesAuthMap
	var authUser []*model.UsersAuthMap
	var match bool
	var updated bool
	log.Print(updated)
	//this is needed to get the custom resource definition
	if err := r.Get(ctx, req.NamespacedName, &rbacDef); err != nil {
		return ctrl.Result{}, client.IgnoreNotFound(err)
	}
	log.Print("RECONCILER: FETCHING EXISTING aws-auth CONFIGMAP")

	//fetch config map from AWS
	awsAuthCm := &corev1.ConfigMap{}
	err := r.Get(ctx, client.ObjectKey{
		Namespace: "kube-system",
		Name:      AUTH_CM_NAME,
	}, awsAuthCm)

	if err != nil {
		ctrl.Log.Error(err, "Failed to get AwsAuth ConfigMap", "Namespace", "kube-system", "Name", AUTH_CM_NAME)
		return ctrl.Result{Requeue: true}, err
	}
	log.Print("RECONCILER: Unmarshalling aws-auth CONFIGMAP")
	err = yaml.Unmarshal([]byte(awsAuthCm.Data["mapRoles"]), &authData.MapRoles)
	err = yaml.Unmarshal([]byte(awsAuthCm.Data["mapUsers"]), &authData.MapUsers)
	authRole = authData.MapRoles
	authUser = authData.MapUsers
	log.Print(rbacDef.Spec.Config)
	log.Print("RECONCILER: ITERATING THROUGH ALL THE RBAC CONFIGS")
	for _, cd := range rbacDef.Spec.Config {
		log.Println(fmt.Sprint("ARN: " + cd.Arn + " ~ UserName: " + cd.UserName))
		if !IsValidType(cd.Type) {
			ctrl.Log.Error(err, "Invalid Type added, check the documentation for valid Type", "Namespace", "", "Name", "")
			return ctrl.Result{Requeue: true}, err
		}
		for _, g := range cd.Groups {

			log.Print("RECONCILER: VALIDATED GROUPS FROM GIVEN LIST")
			if IsCustomGroup(g) {
				grps = append(grps, g)
			}
			if g == CLUSTER_ADMIN {
				grps = append(grps, CLUSTER_EKS_ADMIN_GROUP)
			}
			if g == EC2_NODE {
				grps = append(grps, EC2_EKS_NODES_GROUP)
				grps = append(grps, EC2_EKS_BOOSTRAPPERS_GROUP)
			}
			if g == VIEW_ONLY {
				//Create cluster role and binding for read only
				err := r.createClusterRole(ctx, APPHOSTING_CONSUMER_READONLY_ROLE)
				if err != nil {
					log.Print(err)
				}
				errcrb := r.createClusterRoleBinding(ctx, fmt.Sprintf("%s-binding", APPHOSTING_CONSUMER_READONLY_ROLE), APPHOSTING_CONSUMER_READONLY_ROLE, APPHOSTING_CONSUMER_READONLY_ROLE)
				if errcrb != nil {
					log.Print(err)
				}
				grps = append(grps, APPHOSTING_CONSUMER_READONLY_ROLE)
			}
			if g == NS_ADMIN {
				// Check if Namespace is provided in the input
				if len(cd.Namespaces) > 0 {
					//create namespaces
					log.Print("Reconcile: Creating Provided Namespaces")
					for _, ns := range cd.Namespaces {
						err := r.createNamespace(ctx, ns, req.Name)
						if err != nil {
							log.Print(err)
						}
						grps = append(grps, fmt.Sprintf("%s-%s", APPHOSTING_CONSUMER_ROLE_PREFIX, ns))
						//create role and role binding for each namespace
						errr := r.createRole(ctx, fmt.Sprintf("%s-%s", APPHOSTING_CONSUMER_ROLE_PREFIX, ns), ns)
						if errr != nil {
							log.Print(errr)
						}
						errrb := r.createRoleBinding(ctx, ns, fmt.Sprintf("%s-%s-binding", APPHOSTING_CONSUMER_ROLE_PREFIX, ns), fmt.Sprintf("%s-%s", APPHOSTING_CONSUMER_ROLE_PREFIX, ns), fmt.Sprintf("%s-%s", APPHOSTING_CONSUMER_ROLE_PREFIX, ns))
						if errrb != nil {
							log.Print(errrb)
						}
					}
				}
				// create role and binding for default ns
				errr := r.createRole(ctx, fmt.Sprintf("%s-default", APPHOSTING_CONSUMER_ROLE_PREFIX), "default")
				if errr != nil {
					log.Print(errr)
				}
				errrb := r.createRoleBinding(ctx, "default", fmt.Sprintf("%s-default-binding", APPHOSTING_CONSUMER_ROLE_PREFIX), fmt.Sprintf("%s-default", APPHOSTING_CONSUMER_ROLE_PREFIX), fmt.Sprintf("%s-default", APPHOSTING_CONSUMER_ROLE_PREFIX))
				if errrb != nil {
					log.Print(errrb)
				}
				grps = append(grps, fmt.Sprintf("%s-default", APPHOSTING_CONSUMER_ROLE_PREFIX))

			}
			if g == WRITE_ONLY {
				//Create cluster role and binding for read only
				errcrb := r.createClusterRoleBinding(ctx, fmt.Sprintf("%s-binding", APPHOSTING_CONSUMER_EDIT_ROLE), APPHOSTING_CONSUMER_EDIT_ROLE, APPHOSTING_SYSTEM_EDIT_CLUSTER_ROLE)
				if errcrb != nil {
					log.Print(err)
				}
				grps = append(grps, APPHOSTING_CONSUMER_EDIT_ROLE)
			}

		}
		if cd.Type == ROLE {
			match = false
			updated = false
			log.Print("RECONCILER: Adding provided roles to mapRoles")
			roleResource := model.NewRolesAuthMap(cd.Arn, cd.UserName, grps)
			// check if its a new insert or an update or no change is needed
			for _, existing := range authRole {
				//update
				if existing.RoleARN == roleResource.RoleARN {
					match = true
					// check if the update is needed for username or group
					if existing.Username != roleResource.Username {
						existing.SetUsername(roleResource.Username)
						updated = true
					}
					if !reflect.DeepEqual(existing.Groups, roleResource.Groups) {
						existing.SetGroups(roleResource.Groups)
						updated = true
					}
				}

			}
			//Insert new role
			if !match {
				updated = true
				authRole = append(authRole, roleResource)
			}
			grps = nil

		}

		if cd.Type == USER {
			match = false
			updated = false
			//add mapRoles
			log.Print("RECONCILER: Adding provided users to mapUsers")
			userResources := model.NewUsersAuthMap(cd.Arn, cd.UserName, grps)
			// check if its a new insert or an update or no change is needed
			for _, existing := range authUser {
				//update
				if existing.UserARN == userResources.UserARN {
					match = true
					// check if the update is needed for username or group
					if existing.Username != userResources.Username {
						existing.SetUsername(userResources.Username)
						updated = true
					}
					if !reflect.DeepEqual(existing.Groups, userResources.Groups) {
						existing.SetGroups(userResources.Groups)
						updated = true
					}
				}

			}
			//Insert new user
			if !match {
				updated = true
				authUser = append(authUser, userResources)
			}
			grps = nil
		}

	}
	authData.SetMapRoles(authRole)
	authData.SetMapUsers(authUser)

	//finally call the update for configMap
	log.Print("RECONCILER: Marshalling back mapRoles and mapUsers")
	mr, err := yaml.Marshal(authData.MapRoles)
	if err != nil {
		log.Print(err)
	}
	mu, err := yaml.Marshal(authData.MapUsers)
	if err != nil {
		log.Print(err)
	}

	log.Print("RECONCILER: Updating aws-auth Config Map")

	/* If aws-auth does not have mapUsers(which is the default), we dont want to add mapUsers empty array.
	   Hence the check */
	if len(authData.MapUsers) == 0 {
		awsAuthCm.Data = map[string]string{
			"mapRoles": string(mr),
		}
	} else if len(authData.MapRoles) == 0 {
		awsAuthCm.Data = map[string]string{
			"mapUsers": string(mu),
		}
	} else {
		awsAuthCm.Data = map[string]string{
			"mapRoles": string(mr),
			"mapUsers": string(mu),
		}
	}

	err = r.Update(ctx, awsAuthCm)
	if err != nil {
		log.Print(err)
	}

	return ctrl.Result{}, nil
}

// SetupWithManager sets up the controller with the Manager.
func (r *EksAuthMapReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&eksauthv1.EksAuthMap{}).
		Complete(r)
}
