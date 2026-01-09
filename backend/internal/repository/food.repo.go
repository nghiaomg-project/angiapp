package repository

import (
	"backend/internal/model"
	"context"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

type MongoFoodRepository struct {
	collection *mongo.Collection
}

func NewMongoFoodRepository(db *mongo.Database) *MongoFoodRepository {
	return &MongoFoodRepository{
		collection: db.Collection("foods"),
	}
}

func (r *MongoFoodRepository) GetAll(ctx context.Context) ([]model.Food, error) {
	var foods []model.Food
	cursor, err := r.collection.Find(ctx, bson.M{})
	if err != nil {
		return nil, err
	}
	defer cursor.Close(ctx)

	if err := cursor.All(ctx, &foods); err != nil {
		return nil, err
	}
	return foods, nil
}
