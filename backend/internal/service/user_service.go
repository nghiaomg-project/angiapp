package service

import (
	"backend/internal/model"
	"backend/internal/repository"
	"context"
)

type UserService struct {
	repo repository.UserRepository
}

func NewUserService(repo repository.UserRepository) *UserService {
	return &UserService{repo: repo}
}

func (s *UserService) GetProfile(ctx context.Context, userID string) (*model.User, error) {
	return s.repo.GetByID(ctx, userID)
}

func (s *UserService) Login(ctx context.Context, email, password string) (*model.User, error) {
	// Fake login logic, just check email exist
	return s.repo.GetByEmail(ctx, email)
}
