package repository

import (
	"backend/internal/model"
	"context"
)

type FoodRepository interface {
	GetAll(ctx context.Context) ([]model.Food, error)
	GetByID(ctx context.Context, id string) (*model.Food, error)
	Create(ctx context.Context, food model.Food) error
	Update(ctx context.Context, id string, food model.Food) error
	Delete(ctx context.Context, id string) error
	SearchByIngredients(ctx context.Context, ingredients []string) ([]model.Food, error)
}

type UserRepository interface {
	GetByID(ctx context.Context, id string) (*model.User, error)
	GetByEmail(ctx context.Context, email string) (*model.User, error)
	Create(ctx context.Context, user model.User) error
	Update(ctx context.Context, id string, user model.User) error
}
