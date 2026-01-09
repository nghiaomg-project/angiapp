package handler

import (
	"backend/internal/service"
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
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(foods)
}
