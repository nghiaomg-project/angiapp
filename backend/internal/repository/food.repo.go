package repository

import (
	"backend/internal/model"
	"context"

	"errors"

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
	cursor, err := r.collection.Find(ctx, bson.M{})
	if err != nil {
		return nil, err
	}
	defer cursor.Close(ctx)

	var foods []model.Food
	if err := cursor.All(ctx, &foods); err != nil {
		return nil, err
	}
	return foods, nil
}

func (r *MongoFoodRepository) GetByID(ctx context.Context, id string) (*model.Food, error) {
	var food model.Food
	err := r.collection.FindOne(ctx, bson.M{"_id": id}).Decode(&food)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return nil, errors.New("food not found")
		}
		return nil, err
	}
	return &food, nil
}

func (r *MongoFoodRepository) Create(ctx context.Context, food model.Food) error {
	_, err := r.collection.InsertOne(ctx, food)
	return err
}

func (r *MongoFoodRepository) Update(ctx context.Context, id string, food model.Food) error {
	// Use $set to update fields. Note: This relies on bson struct tags to handle omissions if needed,
	// or assumes 'food' contains the full state to be updated.
	_, err := r.collection.UpdateOne(ctx, bson.M{"_id": id}, bson.M{"$set": food})
	return err
}

func (r *MongoFoodRepository) Delete(ctx context.Context, id string) error {
	_, err := r.collection.DeleteOne(ctx, bson.M{"_id": id})
	return err
}

func (r *MongoFoodRepository) SearchByIngredients(ctx context.Context, ingredients []string) ([]model.Food, error) {
	if len(ingredients) == 0 {
		return []model.Food{}, nil
	}

	// Create a filter to find foods matching ANY of the ingredients (case-insensitive)
	var orConditions []bson.M
	for _, ing := range ingredients {
		orConditions = append(orConditions, bson.M{
			"ingredients.name": bson.M{
				"$regex":   ing,
				"$options": "i",
			},
		})
	}

	filter := bson.M{"$or": orConditions}

	cursor, err := r.collection.Find(ctx, filter)
	if err != nil {
		return nil, err
	}
	defer cursor.Close(ctx)

	var foods []model.Food
	if err := cursor.All(ctx, &foods); err != nil {
		return nil, err
	}
	return foods, nil
}
