package model

type Food struct {
	ID          string `json:"id" bson:"_id,omitempty"`
	Title       string `json:"title" bson:"title"`
	Description string `json:"description" bson:"description"`
	ImageURL    string `json:"image_url" bson:"image_url"`
	ImageAlt    string `json:"image_alt" bson:"image_alt"`
	IsFavorite  bool   `json:"is_favorite" bson:"is_favorite"`
}
