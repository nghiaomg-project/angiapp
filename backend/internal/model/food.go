package model

type Food struct {
	ID          string `json:"id"`
	Title       string `json:"title"`
	Description string `json:"description"`
	ImageURL    string `json:"image_url"`
	ImageAlt    string `json:"image_alt"`
	IsFavorite  bool   `json:"is_favorite"`
}
