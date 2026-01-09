package service

import (
	"backend/internal/dto"
	"backend/internal/model"
	"backend/internal/repository"
	"context"
	"errors"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type FoodService struct {
	repo repository.FoodRepository
}

func NewFoodService(repo repository.FoodRepository) *FoodService {
	return &FoodService{repo: repo}
}

func (s *FoodService) GetFoods(ctx context.Context) ([]dto.FoodResponse, error) {
	foods, err := s.repo.GetAll(ctx)
	if err != nil {
		return nil, err
	}

	var responses []dto.FoodResponse
	for _, f := range foods {
		responses = append(responses, s.mapToResponse(f))
	}
	return responses, nil
}

func (s *FoodService) GetFood(ctx context.Context, id string) (*dto.FoodResponse, error) {
	f, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	if f == nil {
		return nil, errors.New("food not found")
	}
	resp := s.mapToResponse(*f)
	return &resp, nil
}

func (s *FoodService) CreateFood(ctx context.Context, req dto.CreateFoodRequest) (*dto.FoodResponse, error) {
	id := primitive.NewObjectID().Hex()
	food := model.Food{
		ID:          id,
		Title:       req.Title,
		Description: req.Description,
		ImageURL:    req.ImageURL,
		ImageAlt:    req.ImageAlt,
		IsFavorite:  req.IsFavorite,
		Time:        req.Time,
		Difficulty:  req.Difficulty,
		Servings:    req.Servings,
		Ingredients: req.Ingredients,
		Steps:       req.Steps,
	}

	if err := s.repo.Create(ctx, food); err != nil {
		return nil, err
	}

	resp := s.mapToResponse(food)
	return &resp, nil
}

func (s *FoodService) updateFoodFromRequest(current model.Food, req dto.UpdateFoodRequest) model.Food {
	if req.Title != "" {
		current.Title = req.Title
	}
	if req.Description != "" {
		current.Description = req.Description
	}
	if req.ImageURL != "" {
		current.ImageURL = req.ImageURL
	}
	if req.ImageAlt != "" {
		current.ImageAlt = req.ImageAlt
	}
	if req.IsFavorite != nil {
		current.IsFavorite = *req.IsFavorite
	}
	if req.Time != "" {
		current.Time = req.Time
	}
	if req.Difficulty != "" {
		current.Difficulty = req.Difficulty
	}
	if req.Servings != "" {
		current.Servings = req.Servings
	}
	if req.Ingredients != nil {
		current.Ingredients = req.Ingredients
	}
	if req.Steps != nil {
		current.Steps = req.Steps
	}
	return current
}

func (s *FoodService) UpdateFood(ctx context.Context, id string, req dto.UpdateFoodRequest) (*dto.FoodResponse, error) {
	// First get existing food to ensure it exists and to merge updates cleanly
	current, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	if current == nil {
		return nil, errors.New("food not found")
	}

	updatedFood := s.updateFoodFromRequest(*current, req)

	if err := s.repo.Update(ctx, id, updatedFood); err != nil {
		return nil, err
	}

	resp := s.mapToResponse(updatedFood)
	return &resp, nil
}

func (s *FoodService) DeleteFood(ctx context.Context, id string) error {
	return s.repo.Delete(ctx, id)
}

func (s *FoodService) SearchByIngredients(ctx context.Context, req dto.SearchByIngredientsRequest) ([]dto.FoodResponse, error) {
	foods, err := s.repo.SearchByIngredients(ctx, req.Ingredients)
	if err != nil {
		return nil, err
	}

	var responses []dto.FoodResponse
	for _, f := range foods {
		responses = append(responses, s.mapToResponse(f))
	}
	return responses, nil
}

func (s *FoodService) mapToResponse(f model.Food) dto.FoodResponse {
	return dto.FoodResponse{
		ID:          f.ID,
		Title:       f.Title,
		Description: f.Description,
		ImageURL:    f.ImageURL,
		ImageAlt:    f.ImageAlt,
		IsFavorite:  f.IsFavorite,
		Time:        f.Time,
		Difficulty:  f.Difficulty,
		Servings:    f.Servings,
		Ingredients: f.Ingredients,
		Steps:       f.Steps,
	}
}
