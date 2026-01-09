package main

import (
	"backend/internal/handler"
	"backend/internal/repository"
	"backend/internal/router"
	"backend/internal/service"
	"backend/pkg/database"
	"backend/pkg/logger"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"
)

func main() {
	// Load .env file
	if err := godotenv.Load("configs/config.env"); err != nil {
		log.Println("No configs/config.env file found, using defaults")
	}

	appLogger := logger.New()
	appLogger.Info("Starting AnGi Backend...")

	// Database
	mongoURI := os.Getenv("MONGO_URI")
	if mongoURI == "" {
		mongoURI = "mongodb://localhost:27017"
	}
	dbName := os.Getenv("DB_NAME")
	if dbName == "" {
		dbName = "angi_db"
	}

	mongoClient, err := database.ConnectMongoDB(mongoURI)
	if err != nil {
		appLogger.Error("Failed to connect to MongoDB:", err)
		os.Exit(1)
	}
	db := mongoClient.Database(dbName)
	appLogger.Info("Connected to MongoDB")

	// Repositories
	foodRepo := repository.NewMongoFoodRepository(db)
	userRepo := repository.NewMongoUserRepository(db)

	// Services
	foodService := service.NewFoodService(foodRepo)
	userService := service.NewUserService(userRepo)

	// Handlers
	foodHandler := handler.NewFoodHandler(foodService)
	userHandler := handler.NewUserHandler(userService)

	// Router
	mux := router.NewRouter(foodHandler, userHandler)

	// Server
	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}
	serverAddr := ":" + port
	appLogger.Info("Server listening on " + serverAddr)
	if err := http.ListenAndServe(serverAddr, mux); err != nil {
		appLogger.Error("Server failed:", err)
	}
}
