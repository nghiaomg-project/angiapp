package dto

type UserResponse struct {
	ID             string `json:"id"`
	Name           string `json:"name"`
	Email          string `json:"email"`
	Phone          string `json:"phone"`
	Address        string `json:"address"`
	Role           string `json:"role"`
	AvatarURL      string `json:"avatar_url"`
	FavoritesCount int64  `json:"favorites_count"`
	RecipesCount   int64  `json:"recipes_count"`
	MemberSince    string `json:"member_since"`
}

type UpdateProfileRequest struct {
	Name    string `json:"name,omitempty"`
	Phone   string `json:"phone,omitempty"`
	Address string `json:"address,omitempty"`
}
