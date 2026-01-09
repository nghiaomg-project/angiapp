package main

import (
	"backend/internal/handler"
	"backend/internal/repository"
	"backend/internal/service"
	"backend/pkg/logger"
	"net/http"
)

func main() {
	log := logger.New()
	log.Info("Starting AnGi Backend...")

	// Repositories
	foodRepo := repository.NewInMemoryFoodRepository()
	userRepo := repository.NewInMemoryUserRepository()

	// Services
	foodService := service.NewFoodService(foodRepo)
	userService := service.NewUserService(userRepo)

	// Handlers
	foodHandler := handler.NewFoodHandler(foodService)
	userHandler := handler.NewUserHandler(userService)

	// Router
	mux := http.NewServeMux()

	// Middleware
	// Add your middleware here (Logger, CORS, Auth, etc.)

	// Routes
	mux.HandleFunc("GET /api/foods", foodHandler.GetFoods)
	mux.HandleFunc("GET /api/profile", userHandler.GetProfile)
	mux.HandleFunc("POST /api/login", userHandler.Login)
	mux.HandleFunc("GET /health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	})

	// Server
	serverAddr := ":8080"
	log.Info("Server listening on " + serverAddr)
	if err := http.ListenAndServe(serverAddr, mux); err != nil {
		log.Error("Server failed:", err)
	}
}
