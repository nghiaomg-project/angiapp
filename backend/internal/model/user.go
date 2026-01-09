package model

type User struct {
	ID          string `json:"id" bson:"_id,omitempty"`
	Name        string `json:"name" bson:"name"`
	Role        string `json:"role" bson:"role"`
	Email       string `json:"email" bson:"email"`
	Phone       string `json:"phone" bson:"phone"`
	Address     string `json:"address" bson:"address"`
	AvatarURL   string `json:"avatar_url" bson:"avatar_url"`
	MemberSince string `json:"member_since" bson:"member_since"`
}
