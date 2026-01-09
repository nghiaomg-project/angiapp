package handler

import (
	"backend/internal/dto"
	"backend/internal/service"
	"backend/pkg/response"
	"encoding/json"
	"net/http"
)

type UserHandler struct {
	service *service.UserService
}

func NewUserHandler(service *service.UserService) *UserHandler {
	return &UserHandler{service: service}
}

func (h *UserHandler) GetProfile(w http.ResponseWriter, r *http.Request) {
	// For demo, assume hardcoded user ID logic or token extraction
	// In real app, extracting from Context (set by middleware)
	userID := "1"

	user, err := h.service.GetProfile(r.Context(), userID)
	w.Header().Set("Content-Type", "application/json")
	if err != nil {
		code, resp := response.Error("User not found").SendWithStatus(200, 404)
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	code, resp := response.Success(user).Send()
	w.WriteHeader(code)
	json.NewEncoder(w).Encode(resp)
}

func (h *UserHandler) UpdateProfile(w http.ResponseWriter, r *http.Request) {
	userID := "1" // Check auth middleware in real app

	var req dto.UpdateProfileRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		w.Header().Set("Content-Type", "application/json")
		code, resp := response.Error("Invalid request body").SendWithStatus(200, 400)
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	user, err := h.service.UpdateProfile(r.Context(), userID, req)
	w.Header().Set("Content-Type", "application/json")
	if err != nil {
		code, resp := response.Error(err.Error()).Send()
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	code, resp := response.Success(user).Send()
	w.WriteHeader(code)
	json.NewEncoder(w).Encode(resp)
}

func (h *UserHandler) Login(w http.ResponseWriter, r *http.Request) {
	var creds dto.LoginRequest

	w.Header().Set("Content-Type", "application/json")
	if err := json.NewDecoder(r.Body).Decode(&creds); err != nil {
		code, resp := response.Error("Invalid request body").SendWithStatus(200, 400)
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	user, err := h.service.Login(r.Context(), creds.Email, creds.Password)
	if err != nil {
		code, resp := response.Error(err.Error()).SendWithStatus(200, 401)
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	code, resp := response.Success(user).Send()
	w.WriteHeader(code)
	json.NewEncoder(w).Encode(resp)
}

func (h *UserHandler) GoogleLogin(w http.ResponseWriter, r *http.Request) {
	var req dto.GoogleLoginRequest

	w.Header().Set("Content-Type", "application/json")
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		code, resp := response.Error("Invalid request body").SendWithStatus(200, 400)
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	user, err := h.service.LoginWithGoogle(r.Context(), req.IDToken)
	if err != nil {
		code, resp := response.Error("Google login failed: "+err.Error()).SendWithStatus(200, 401)
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	code, resp := response.Success(user).Send()
	w.WriteHeader(code)
	json.NewEncoder(w).Encode(resp)
}
