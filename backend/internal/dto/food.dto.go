package dto

type CreateFoodRequest struct {
	Title       string `json:"title" validate:"required"`
	Description string `json:"description"`
	ImageURL    string `json:"image_url"`
	ImageAlt    string `json:"image_alt"`
	IsFavorite  bool   `json:"is_favorite"`
}

type UpdateFoodRequest struct {
	Title       string `json:"title,omitempty"`
	Description string `json:"description,omitempty"`
	ImageURL    string `json:"image_url,omitempty"`
	ImageAlt    string `json:"image_alt,omitempty"`
	IsFavorite  *bool  `json:"is_favorite,omitempty"`
}

type FoodResponse struct {
	ID          string `json:"id"`
	Title       string `json:"title"`
	Description string `json:"description"`
	ImageURL    string `json:"image_url"`
	ImageAlt    string `json:"image_alt"`
	IsFavorite  bool   `json:"is_favorite"`
}
