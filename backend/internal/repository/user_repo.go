package repository

import (
	"backend/internal/model"
	"context"
	"errors"
)

type UserRepository interface {
	GetByID(ctx context.Context, id string) (*model.User, error)
	GetByEmail(ctx context.Context, email string) (*model.User, error)
}

type InMemoryUserRepository struct {
	users []model.User
}

func NewInMemoryUserRepository() *InMemoryUserRepository {
	return &InMemoryUserRepository{
		users: []model.User{
			{
				ID:          "1",
				Name:        "John Doe",
				Role:        "Food Enthusiast",
				Email:       "john.doe@example.com",
				Phone:       "+1 234 567 8900",
				Address:     "123 Main Street, City",
				MemberSince: "January 2024",
			},
		},
	}
}

func (r *InMemoryUserRepository) GetByID(ctx context.Context, id string) (*model.User, error) {
	for _, u := range r.users {
		if u.ID == id {
			return &u, nil
		}
	}
	return nil, errors.New("user not found")
}

func (r *InMemoryUserRepository) GetByEmail(ctx context.Context, email string) (*model.User, error) {
	for _, u := range r.users {
		if u.Email == email {
			return &u, nil
		}
	}
	return nil, errors.New("user not found")
}
