package router

import (
	"backend/internal/handler"
	"backend/internal/middleware"
	"log/slog"
	"net/http"
	"os"

	"github.com/go-chi/httplog/v3"
)

func NewRouter(foodHandler *handler.FoodHandler, userHandler *handler.UserHandler) http.Handler {
	// Logger configuration
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))

	options := &httplog.Options{
		Level:         slog.LevelInfo,
		RecoverPanics: true,
	}

	mux := http.NewServeMux()

	// Food Routes
	mux.HandleFunc("GET /api/foods", foodHandler.GetFoods)
	mux.HandleFunc("GET /api/foods/{id}", foodHandler.GetFood)
	mux.HandleFunc("POST /api/foods", foodHandler.CreateFood)
	mux.HandleFunc("POST /api/foods/search/ingredients", foodHandler.SearchByIngredients)
	mux.HandleFunc("PUT /api/foods/{id}", foodHandler.UpdateFood)
	mux.HandleFunc("POST /api/foods/{id}/favorite", foodHandler.ToggleFavorite)
	mux.HandleFunc("DELETE /api/foods/{id}", foodHandler.DeleteFood)

	// User Routes
	mux.Handle("GET /api/profile", middleware.AuthMiddleware(http.HandlerFunc(userHandler.GetProfile)))
	mux.Handle("PUT /api/profile", middleware.AuthMiddleware(http.HandlerFunc(userHandler.UpdateProfile)))

	// Auth Routes
	mux.HandleFunc("POST /api/login", userHandler.Login)
	mux.HandleFunc("POST /api/login/google", userHandler.GoogleLogin)

	// Health Check
	mux.HandleFunc("GET /health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	})

	return httplog.RequestLogger(logger, options)(mux)
}
