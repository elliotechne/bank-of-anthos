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

package v1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.
type ConfigData struct {
	Arn        string   `json:"arn"`
	UserName   string   `json:"username"`
	Type       string   `json:"type"`
	Groups     []string `json:"groups"`
	Namespaces []string `json:"namespaces,omitempty"`
}

// EksAuthMapSpec defines the desired state of EksAuthMap
type EksAuthMapSpec struct {
	// INSERT ADDITIONAL SPEC FIELDS - desired state of cluster
	// Important: Run "make" to regenerate code after modifying this file

	// Foo is an example field of EksAuthMap. Edit eksauthmap_types.go to remove/update
	Config []ConfigData `json:"config"`
}

// EksAuthMapStatus defines the observed state of EksAuthMap
type EksAuthMapStatus struct {
	// INSERT ADDITIONAL STATUS FIELD - define observed state of cluster
	// Important: Run "make" to regenerate code after modifying this file
}

//+kubebuilder:object:root=true
//+kubebuilder:subresource:status

// EksAuthMap is the Schema for the eksauthmaps API
type EksAuthMap struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   EksAuthMapSpec   `json:"spec,omitempty"`
	Status EksAuthMapStatus `json:"status,omitempty"`
}

//+kubebuilder:object:root=true

// EksAuthMapList contains a list of EksAuthMap
type EksAuthMapList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []EksAuthMap `json:"items"`
}

func init() {
	SchemeBuilder.Register(&EksAuthMap{}, &EksAuthMapList{})
}
