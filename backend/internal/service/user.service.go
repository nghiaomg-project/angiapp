package service

import (
	"backend/internal/dto"
	"backend/internal/model"
	"backend/internal/repository"
	"backend/pkg/token"
	"context"
	"errors"
	"fmt"
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
	"google.golang.org/api/idtoken"
)

const GoogleClientID = "15308212703-kirk5o46clff1n3s4lgnnb0dfgcf8g0u.apps.googleusercontent.com"

type UserService struct {
	repo     repository.UserRepository
	foodRepo repository.FoodRepository
}

func NewUserService(repo repository.UserRepository, foodRepo repository.FoodRepository) *UserService {
	return &UserService{repo: repo, foodRepo: foodRepo}
}

func (s *UserService) toUserResponse(u *model.User) dto.UserResponse {
	return dto.UserResponse{
		ID:          u.ID,
		Name:        u.Name,
		Email:       u.Email,
		Phone:       u.Phone,
		Address:     u.Address,
		Role:        u.Role,
		AvatarURL:   u.AvatarURL,
		MemberSince: u.MemberSince,
	}
}

func (s *UserService) getUserResponseWithStats(ctx context.Context, u *model.User) dto.UserResponse {
	res := s.toUserResponse(u)
	fav, _ := s.foodRepo.CountFavorites(ctx)
	res.FavoritesCount = fav
	all, _ := s.foodRepo.CountAll(ctx)
	res.RecipesCount = all
	return res
}

func (s *UserService) GetProfile(ctx context.Context, userID string) (*dto.UserResponse, error) {
	user, err := s.repo.GetByID(ctx, userID)
	if err != nil {
		return nil, err
	}
	res := s.getUserResponseWithStats(ctx, user)
	return &res, nil
}

func (s *UserService) Login(ctx context.Context, email, password string) (*dto.LoginResponse, error) {
	user, err := s.repo.GetByEmail(ctx, email)
	if err != nil {
		return nil, errors.New("invalid credentials")
	}

	// TODO: Verify password hash here. For now assuming password matches for demo.

	accessToken, refreshToken, err := token.GenerateTokenPair(user.ID)
	if err != nil {
		return nil, err
	}
	return &dto.LoginResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		User:         s.getUserResponseWithStats(ctx, user),
	}, nil
}

func (s *UserService) LoginWithGoogle(ctx context.Context, idToken string) (*dto.LoginResponse, error) {
	payload, err := idtoken.Validate(ctx, idToken, GoogleClientID)
	if err != nil {
		return nil, fmt.Errorf("invalid google token: %v", err)
	}

	email, ok := payload.Claims["email"].(string)
	if !ok {
		return nil, fmt.Errorf("token does not contain email")
	}
	picture, _ := payload.Claims["picture"].(string)

	var user *model.User
	user, err = s.repo.GetByEmail(ctx, email)
	if err != nil {
		// New user
		name, _ := payload.Claims["name"].(string)
		newUser := model.User{
			ID:          primitive.NewObjectID().Hex(),
			Name:        name,
			Email:       email,
			Role:        "User",
			AvatarURL:   picture,
			MemberSince: time.Now().Format("January 2006"),
		}
		if err := s.repo.Create(ctx, newUser); err != nil {
			return nil, err
		}
		user = &newUser
	} else {
		// Update existing user avatar if changed
		if picture != "" && user.AvatarURL != picture {
			user.AvatarURL = picture
			s.repo.Update(ctx, user.ID, *user)
		}
	}

	accessToken, refreshToken, err := token.GenerateTokenPair(user.ID)
	if err != nil {
		return nil, err
	}
	return &dto.LoginResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		User:         s.getUserResponseWithStats(ctx, user),
	}, nil
}

func (s *UserService) UpdateProfile(ctx context.Context, id string, req dto.UpdateProfileRequest) (*dto.UserResponse, error) {
	user, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	if user == nil {
		return nil, errors.New("user not found")
	}

	if req.Name != "" {
		user.Name = req.Name
	}
	if req.Phone != "" {
		user.Phone = req.Phone
	}
	if req.Address != "" {
		user.Address = req.Address
	}

	if err := s.repo.Update(ctx, id, *user); err != nil {
		return nil, err
	}

	res := s.getUserResponseWithStats(ctx, user)
	return &res, nil
}
