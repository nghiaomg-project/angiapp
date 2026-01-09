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
		responses = append(responses, dto.FoodResponse{
			ID:          f.ID,
			Title:       f.Title,
			Description: f.Description,
			ImageURL:    f.ImageURL,
			ImageAlt:    f.ImageAlt,
			IsFavorite:  f.IsFavorite,
		})
	}
	return responses, nil
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
	}

	if err := s.repo.Create(ctx, food); err != nil {
		return nil, err
	}

	return &dto.FoodResponse{
		ID:          food.ID,
		Title:       food.Title,
		Description: food.Description,
		ImageURL:    food.ImageURL,
		ImageAlt:    food.ImageAlt,
		IsFavorite:  food.IsFavorite,
	}, nil
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

	return &dto.FoodResponse{
		ID:          updatedFood.ID,
		Title:       updatedFood.Title,
		Description: updatedFood.Description,
		ImageURL:    updatedFood.ImageURL,
		ImageAlt:    updatedFood.ImageAlt,
		IsFavorite:  updatedFood.IsFavorite,
	}, nil
}

func (s *FoodService) DeleteFood(ctx context.Context, id string) error {
	return s.repo.Delete(ctx, id)
}
