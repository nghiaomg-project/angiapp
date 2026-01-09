package dto

import "backend/internal/model"

type CreateFoodRequest struct {
	Title       string             `json:"title" validate:"required"`
	Description string             `json:"description"`
	ImageURL    string             `json:"image_url"`
	ImageAlt    string             `json:"image_alt"`
	IsFavorite  bool               `json:"is_favorite"`
	Time        string             `json:"time"`
	Difficulty  string             `json:"difficulty"`
	Servings    string             `json:"servings"`
	Ingredients []model.Ingredient `json:"ingredients"`
	Steps       []model.Step       `json:"steps"`
}

type UpdateFoodRequest struct {
	Title       string             `json:"title,omitempty"`
	Description string             `json:"description,omitempty"`
	ImageURL    string             `json:"image_url,omitempty"`
	ImageAlt    string             `json:"image_alt,omitempty"`
	IsFavorite  *bool              `json:"is_favorite,omitempty"`
	Time        string             `json:"time,omitempty"`
	Difficulty  string             `json:"difficulty,omitempty"`
	Servings    string             `json:"servings,omitempty"`
	Ingredients []model.Ingredient `json:"ingredients,omitempty"`
	Steps       []model.Step       `json:"steps,omitempty"`
}

type FoodResponse struct {
	ID          string             `json:"id"`
	Title       string             `json:"title"`
	Description string             `json:"description"`
	ImageURL    string             `json:"image_url"`
	ImageAlt    string             `json:"image_alt"`
	IsFavorite  bool               `json:"is_favorite"`
	Time        string             `json:"time"`
	Difficulty  string             `json:"difficulty"`
	Servings    string             `json:"servings"`
	Ingredients []model.Ingredient `json:"ingredients"`
	Steps       []model.Step       `json:"steps"`
}

type SearchByIngredientsRequest struct {
	Ingredients []string `json:"ingredients" validate:"required"`
}
