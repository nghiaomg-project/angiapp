package model

type Ingredient struct {
	Name   string `json:"name" bson:"name"`
	Amount string `json:"amount" bson:"amount"`
}

type Step struct {
	Index       int    `json:"index" bson:"index"`
	Title       string `json:"title" bson:"title"`
	Description string `json:"description" bson:"description"`
	ImageURL    string `json:"image_url,omitempty" bson:"image_url,omitempty"`
}

type Food struct {
	ID          string       `json:"id" bson:"_id,omitempty"`
	Title       string       `json:"title" bson:"title"`
	Description string       `json:"description" bson:"description"`
	ImageURL    string       `json:"image_url" bson:"image_url"`
	ImageAlt    string       `json:"image_alt" bson:"image_alt"`
	IsFavorite  bool         `json:"is_favorite" bson:"is_favorite"`
	Time        string       `json:"time" bson:"time"`
	Difficulty  string       `json:"difficulty" bson:"difficulty"`
	Servings    string       `json:"servings" bson:"servings"`
	Ingredients []Ingredient `json:"ingredients" bson:"ingredients"`
	Steps       []Step       `json:"steps" bson:"steps"`
}
