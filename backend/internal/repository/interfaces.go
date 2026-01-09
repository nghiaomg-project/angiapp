package repository

import (
	"backend/internal/model"
	"context"
)

type FoodRepository interface {
	GetAll(ctx context.Context) ([]model.Food, error)
}

type UserRepository interface {
	GetByID(ctx context.Context, id string) (*model.User, error)
	GetByEmail(ctx context.Context, email string) (*model.User, error)
	Create(ctx context.Context, user model.User) error
}
