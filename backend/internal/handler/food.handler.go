package handler

import (
	"backend/internal/dto"
	"backend/internal/service"
	"backend/pkg/response"
	"encoding/json"
	"net/http"
)

type FoodHandler struct {
	service *service.FoodService
}

func NewFoodHandler(service *service.FoodService) *FoodHandler {
	return &FoodHandler{service: service}
}

func (h *FoodHandler) GetFoods(w http.ResponseWriter, r *http.Request) {
	foods, err := h.service.GetFoods(r.Context())
	w.Header().Set("Content-Type", "application/json")
	if err != nil {
		code, resp := response.Error(err.Error()).Send()
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	code, resp := response.Success(foods).Send()
	w.WriteHeader(code)
	json.NewEncoder(w).Encode(resp)
}

func (h *FoodHandler) GetFood(w http.ResponseWriter, r *http.Request) {
	id := r.PathValue("id")
	if id == "" {
		w.Header().Set("Content-Type", "application/json")
		code, resp := response.Error("Missing food ID").SendWithStatus(200, 400)
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	food, err := h.service.GetFood(r.Context(), id)
	w.Header().Set("Content-Type", "application/json")
	if err != nil {
		code, resp := response.Error(err.Error()).Send()
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	code, resp := response.Success(food).Send()
	w.WriteHeader(code)
	json.NewEncoder(w).Encode(resp)
}

func (h *FoodHandler) CreateFood(w http.ResponseWriter, r *http.Request) {
	var req dto.CreateFoodRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		w.Header().Set("Content-Type", "application/json")
		code, resp := response.Error("Invalid request body").SendWithStatus(200, 400)
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	food, err := h.service.CreateFood(r.Context(), req)
	w.Header().Set("Content-Type", "application/json")
	if err != nil {
		code, resp := response.Error(err.Error()).Send()
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	code, resp := response.Success(food).Send()
	w.WriteHeader(code)
	json.NewEncoder(w).Encode(resp)
}

func (h *FoodHandler) UpdateFood(w http.ResponseWriter, r *http.Request) {
	id := r.PathValue("id")
	if id == "" {
		w.Header().Set("Content-Type", "application/json")
		code, resp := response.Error("Missing food ID").SendWithStatus(200, 400)
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	var req dto.UpdateFoodRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		w.Header().Set("Content-Type", "application/json")
		code, resp := response.Error("Invalid request body").SendWithStatus(200, 400)
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	food, err := h.service.UpdateFood(r.Context(), id, req)
	w.Header().Set("Content-Type", "application/json")
	if err != nil {
		code, resp := response.Error(err.Error()).Send()
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	code, resp := response.Success(food).Send()
	w.WriteHeader(code)
	json.NewEncoder(w).Encode(resp)
}

func (h *FoodHandler) DeleteFood(w http.ResponseWriter, r *http.Request) {
	id := r.PathValue("id")
	if id == "" {
		w.Header().Set("Content-Type", "application/json")
		code, resp := response.Error("Missing food ID").SendWithStatus(200, 400)
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	err := h.service.DeleteFood(r.Context(), id)
	w.Header().Set("Content-Type", "application/json")
	if err != nil {
		code, resp := response.Error(err.Error()).Send()
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	code, resp := response.Success("Food deleted successfully").Send()
	w.WriteHeader(code)
	json.NewEncoder(w).Encode(resp)
}

func (h *FoodHandler) SearchByIngredients(w http.ResponseWriter, r *http.Request) {
	var req dto.SearchByIngredientsRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		w.Header().Set("Content-Type", "application/json")
		code, resp := response.Error("Invalid request body").SendWithStatus(200, 400)
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	foods, err := h.service.SearchByIngredients(r.Context(), req)
	w.Header().Set("Content-Type", "application/json")
	if err != nil {
		code, resp := response.Error(err.Error()).Send()
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	code, resp := response.Success(foods).Send()
	w.WriteHeader(code)
	json.NewEncoder(w).Encode(resp)
}

func (h *FoodHandler) ToggleFavorite(w http.ResponseWriter, r *http.Request) {
	id := r.PathValue("id")
	if id == "" {
		w.Header().Set("Content-Type", "application/json")
		code, resp := response.Error("Missing food ID").SendWithStatus(200, 400)
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	food, err := h.service.ToggleFavorite(r.Context(), id)
	w.Header().Set("Content-Type", "application/json")
	if err != nil {
		code, resp := response.Error(err.Error()).Send()
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(resp)
		return
	}

	code, resp := response.Success(food).Send()
	w.WriteHeader(code)
	json.NewEncoder(w).Encode(resp)
}
