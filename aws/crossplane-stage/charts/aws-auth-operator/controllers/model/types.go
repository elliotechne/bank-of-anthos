package model

import (
	"fmt"
	"strings"
)

// AwsAuthData represents the data of the aws-auth configmap
type AwsAuthData struct {
	MapRoles []*RolesAuthMap `yaml:"mapRoles"`
	MapUsers []*UsersAuthMap `yaml:"mapUsers"`
}

// SetMapRoles sets the MapRoles element
func (m *AwsAuthData) SetMapRoles(authMap []*RolesAuthMap) {
	m.MapRoles = authMap
}

// SetMapUsers sets the MapUsers element
func (m *AwsAuthData) SetMapUsers(authMap []*UsersAuthMap) {
	m.MapUsers = authMap
}

type RolesAuthMap struct {
	RoleARN  string   `yaml:"rolearn"`
	Username string   `yaml:"username"`
	Groups   []string `yaml:"groups,omitempty"`
}

func (r *RolesAuthMap) String() string {
	var s strings.Builder
	s.WriteString(fmt.Sprintf("- rolearn: %v\n  ", r.RoleARN))
	s.WriteString(fmt.Sprintf("username: %v\n  ", r.Username))
	s.WriteString("groups:\n")
	for _, group := range r.Groups {
		s.WriteString(fmt.Sprintf("  - %v\n", group))
	}
	return s.String()
}

// UsersAuthMap is the basic structure of a mapUsers authentication object
type UsersAuthMap struct {
	UserARN  string   `yaml:"userarn"`
	Username string   `yaml:"username"`
	Groups   []string `yaml:"groups,omitempty"`
}

func (r *UsersAuthMap) String() string {
	var s strings.Builder
	s.WriteString(fmt.Sprintf("- userarn: %v\n  ", r.UserARN))
	s.WriteString(fmt.Sprintf("username: %v\n  ", r.Username))
	s.WriteString("groups:\n")
	for _, group := range r.Groups {
		s.WriteString(fmt.Sprintf("  - %v\n", group))
	}
	return s.String()
}

// NewRolesAuthMap returns a new NewRolesAuthMap
func NewRolesAuthMap(rolearn, username string, groups []string) *RolesAuthMap {
	return &RolesAuthMap{
		RoleARN:  rolearn,
		Username: username,
		Groups:   groups,
	}
}

// NewUsersAuthMap returns a new NewUsersAuthMap
func NewUsersAuthMap(userarn, username string, groups []string) *UsersAuthMap {
	return &UsersAuthMap{
		UserARN:  userarn,
		Username: username,
		Groups:   groups,
	}
}

// SetUsername sets the Username value
func (r *UsersAuthMap) SetUsername(v string) *UsersAuthMap {
	r.Username = v
	return r
}

// SetGroups sets the Groups value
func (r *UsersAuthMap) SetGroups(g []string) *UsersAuthMap {
	r.Groups = g
	return r
}

// SetUsername sets the Username value
func (r *RolesAuthMap) SetUsername(v string) *RolesAuthMap {
	r.Username = v
	return r
}

// SetGroups sets the Groups value
func (r *RolesAuthMap) SetGroups(g []string) *RolesAuthMap {
	r.Groups = g
	return r
}
