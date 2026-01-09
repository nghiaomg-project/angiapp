package handler

import (
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
