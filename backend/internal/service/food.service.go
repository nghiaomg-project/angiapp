package service

import (
	"backend/internal/model"
	"backend/internal/repository"
	"context"
)

type FoodService struct {
	repo repository.FoodRepository
}

func NewFoodService(repo repository.FoodRepository) *FoodService {
	return &FoodService{repo: repo}
}

func (s *FoodService) GetFoods(ctx context.Context) ([]model.Food, error) {
	return s.repo.GetAll(ctx)
}
