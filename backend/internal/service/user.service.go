package service

import (
	"backend/internal/model"
	"backend/internal/repository"
	"context"
	"fmt"
	"time"

	"google.golang.org/api/idtoken"
)

const GoogleClientID = "15308212703-kirk5o46clff1n3s4lgnnb0dfgcf8g0u.apps.googleusercontent.com"

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

func (s *UserService) LoginWithGoogle(ctx context.Context, idToken string) (*model.User, error) {
	payload, err := idtoken.Validate(ctx, idToken, GoogleClientID)
	if err != nil {
		return nil, fmt.Errorf("invalid google token: %v", err)
	}

	email, ok := payload.Claims["email"].(string)
	if !ok {
		return nil, fmt.Errorf("token does not contain email")
	}

	// Try to find user
	user, err := s.repo.GetByEmail(ctx, email)
	if err == nil {
		return user, nil
	}

	// Create new user if not exists
	name, _ := payload.Claims["name"].(string)
	newUser := model.User{
		ID:          fmt.Sprintf("%d", time.Now().UnixNano()), // Simple ID generation
		Name:        name,
		Email:       email,
		Role:        "User",
		MemberSince: time.Now().Format("January 2006"),
	}

	if err := s.repo.Create(ctx, newUser); err != nil {
		return nil, err
	}

	return &newUser, nil
}
