package main

import (
	"backend/internal/model"
	"backend/internal/repository"
	"backend/pkg/database"
	"context"
	"log"
	"os"
	"time"

	"github.com/joho/godotenv"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func main() {
	// Load .env
	if err := godotenv.Load("configs/config.env"); err != nil {
		if err := godotenv.Load("../../configs/config.env"); err != nil {
			log.Println("Warning: No config file found")
		}
	}

	mongoURI := os.Getenv("MONGO_URI")
	if mongoURI == "" {
		mongoURI = "mongodb://localhost:27017"
	}
	dbName := os.Getenv("DB_NAME")
	if dbName == "" {
		dbName = "angi_db"
	}

	client, err := database.ConnectMongoDB(mongoURI)
	if err != nil {
		log.Fatal(err)
	}
	db := client.Database(dbName)
	repo := repository.NewMongoFoodRepository(db)

	foods := []model.Food{
		{
			ID:          primitive.NewObjectID().Hex(),
			Title:       "Bún Chả Hà Nội",
			Description: "Thịt nướng than hoa thơm lừng, ăn kèm bún rối trắng ngần và nước chấm chua ngọt đậm đà hương vị truyền thống. Món ăn tinh hoa của ẩm thực Hà Thành.",
			ImageURL:    "https://lh3.googleusercontent.com/aida-public/AB6AXuCs1q6Yieitc_5768o2jGPhguLqqVCZb6O2VHjY_Ye-9yglzKV1upX8dMtgavabF6VCFwtjpn5z1QWXs0AzUXTD6R4c6IbiDCPN91-30kP0IDRMLu1YuxFcsLV2Fix9xaWRlnJX9Ib6IlI3X_2GSPprSAYtsIr3DP3mmW6evDsevwsr_EO-TeypCcBizOu2aZ0MAg3J2bKiiJZuJWX_lGR3DNdvb3vVm1uVSGNMlegH1jsqLxyiyvrvVloaVDgEb3gX5VnDMWWa1LuL",
			ImageAlt:    "Grilled pork patties with noodles and dipping sauce",
			IsFavorite:  false,
			Time:        "60 phút",
			Difficulty:  "Trung bình",
			Servings:    "4 người",
			Ingredients: []model.Ingredient{
				{Name: "Thịt ba chỉ", Amount: "500g"},
				{Name: "Thịt nạc vai", Amount: "500g"},
				{Name: "Bún tươi", Amount: "1kg"},
				{Name: "Đu đủ xanh, cà rốt", Amount: "1 quả/củ"},
				{Name: "Rau sống", Amount: "500g"},
				{Name: "Gia vị ướp", Amount: "Đường, mắm, hành tím, tiêu"},
			},
			Steps: []model.Step{
				{Index: 1, Title: "Sơ chế thịt", Description: "Rửa sạch thịt. Thái thịt ba chỉ thành miếng vừa ăn. Thịt nạc vai băm nhỏ để làm chả viên."},
				{Index: 2, Title: "Ướp thịt", Description: "Ướp thịt với nước hàng, đường, mắm, hạt tiêu, hành tím băm nhỏ. Để ngấm ít nhất 30 phút."},
				{Index: 3, Title: "Nướng chả", Description: "Xếp thịt lên vỉ nướng. Nướng trên than hoa cho đến khi thịt chín vàng, có mùi thơm lừng."},
				{Index: 4, Title: "Pha nước chấm", Description: "Pha nước mắm, đường, giấm, nước lọc theo tỷ lệ vàng. Thêm tỏi, ớt băm và đu đủ, cà rốt tỉa hoa."},
				{Index: 5, Title: "Thưởng thức", Description: "Bày chả, bún, rau sống ra đĩa. Chấm ngập thịt và bún vào bát nước chấm."},
			},
		},
		{
			ID:          primitive.NewObjectID().Hex(),
			Title:       "Bánh Xèo Miền Tây",
			Description: "Vỏ bánh vàng ươm giòn rụm, nhân tôm thịt đầy đặn cùng giá đỗ, cuốn rau sống chấm mắm chua ngọt. Đặc sản dân dã miền Tây Nam Bộ.",
			ImageURL:    "https://lh3.googleusercontent.com/aida-public/AB6AXuBx0E2FjzFsMskL5edfdvFJkPIC8Xgdn01n1StOEWHL5Fr0-UXp4y-urdOunpN-_gZLSLGbmsros977Zotkh_AUx3cqM9w-la0cX8cEVBac7USm1tXl42Nzqr2cLCPffYu5lnXwJNch-2ceRhKNeuE2SPRhmPA200s99_27wx6mwuIoL7CsS2jcTbdXc3xg3A370YPP5_EGAGfX1ppY9KIFuVgEvTvcun8MDaSa81MLMEWdV6esMJClMM1fSJpgiwZ62t_frjNHPz2q",
			ImageAlt:    "Crispy yellow Vietnamese pancake filled with shrimp and sprouts",
			IsFavorite:  true,
			Time:        "45 phút",
			Difficulty:  "Dễ",
			Servings:    "4 cái",
			Ingredients: []model.Ingredient{
				{Name: "Bột bánh xèo", Amount: "1 gói"},
				{Name: "Tôm tươi", Amount: "300g"},
				{Name: "Thịt ba chỉ", Amount: "300g"},
				{Name: "Giá đỗ", Amount: "200g"},
				{Name: "Nước cốt dừa", Amount: "1 chén"},
				{Name: "Rau cải xanh, xà lách", Amount: "500g"},
			},
			Steps: []model.Step{
				{Index: 1, Title: "Pha bột", Description: "Pha bột bánh xèo với nước, nước cốt dừa và hành lá cắt nhỏ. Để bột nghỉ 15 phút."},
				{Index: 2, Title: "Xào nhân", Description: "Xào sơ tôm và thịt ba chỉ cho chín tới."},
				{Index: 3, Title: "Đổ bánh", Description: "Cho ít dầu vào chảo nóng, đổ một vá bột tráng đều. Cho nhân tôm thịt và giá đỗ vào. Đậy nắp chờ chín."},
				{Index: 4, Title: "Gập bánh", Description: "Khi vỏ bánh vàng giòn, gập đôi bánh lại và cho ra đĩa."},
				{Index: 5, Title: "Thưởng thức", Description: "Cắt bánh thành miếng, cuốn với rau sống và bánh tráng, chấm mắm chua ngọt."},
			},
		},
		{
			ID:          primitive.NewObjectID().Hex(),
			Title:       "Phở Bò Tái Nạm",
			Description: "Nước dùng ngọt thanh từ xương hầm 24h, bánh phở mềm dai và thịt bò tươi ngon thượng hạng. Món ăn quốc hồn quốc túy của Việt Nam.",
			ImageURL:    "https://lh3.googleusercontent.com/aida-public/AB6AXuChsqG0EhDYhWGXH0i17bgKT0qd557VMU5ERoeu7yBe1_XhvzjQQuHVwyiVEsIf8Oc5WiiRa72FG-PBtdSpEtsQbfupdElf7CD3Agybb1NY3f-vMMYcgv3FOnogKV3xlVsOHXxPO4OtNpoWfedSYHqmDsivY9GkWnuuYgY08FnvPOjoZaF4vPSvUwwC1b5mhCPqF6dYlrizATPC5EEtLSku0nwAvl9BwkxWCeMh3YfYeQhaIpPdrYYPgtkng4YZ7uZZMaGB0CGPl-Yq",
			ImageAlt:    "Traditional beef noodle soup in a bowl",
			IsFavorite:  false,
			Time:        "3 giờ",
			Difficulty:  "Khó",
			Servings:    "6 người",
			Ingredients: []model.Ingredient{
				{Name: "Xương ống bò", Amount: "2kg"},
				{Name: "Thịt bò tái/nạm", Amount: "1kg"},
				{Name: "Bánh phở", Amount: "1.5kg"},
				{Name: "Gói gia vị phở", Amount: "1 gói (Hồi, quế, thảo quả)"},
				{Name: "Hành tây, gừng nướng", Amount: "3 củ"},
			},
			Steps: []model.Step{
				{Index: 1, Title: "Sơ chế xương", Description: "Xương bò rửa sạch, chần qua nước sôi 5 phút rồi rửa lại lần nữa."},
				{Index: 2, Title: "Ninh nước dùng", Description: "Ninh xương với 5 lít nước trong 3-4 tiếng. Thêm hành tây, gừng nướng và gia vị phở vào 1 tiếng cuối."},
				{Index: 3, Title: "Chuẩn bị thịt", Description: "Thịt nạm luộc chín trong nồi nước dùng rồi thái mỏng. Thịt tái thái lát mỏng."},
				{Index: 4, Title: "Hoàn thiện bát phở", Description: "Chần bánh phở, xếp vào bát. Thêm thịt, hành lá. Chan nước dùng sôi lên trên."},
			},
		},
	}

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	log.Println("Clearing existing foods...")
	// Note: For simplicity, we won't delete all here, but repo.Create will fail if ID exists (handled or unique constraint).
	// But Mongo Create usually uses ObjectID if not specified, or just inserts.
	// Since we defined specific IDs above? No, primitive.NewObjectID().Hex() generates new ones.
	// So seeding will duplicates if we don't clear.
	// We don't have DeleteAll in repo. But we can ignore or just add.
	// Let's implement DeleteAll or just rely on manual clearing if needed.
	// For this task, duplicate/growing list is fine, or I can just assume empty for now.
	// Actually better to "Drop" collection if I want clean state.
	if err := db.Collection("foods").Drop(ctx); err != nil {
		log.Println("Warning: failed to drop foods collection or it didn't exist")
	}

	log.Println("Seeding foods...")
	for _, food := range foods {
		if err := repo.Create(ctx, food); err != nil {
			log.Printf("Failed to seed %s: %v\n", food.Title, err)
		} else {
			log.Printf("Seeded %s\n", food.Title)
		}
	}
	log.Println("Seeding complete.")
}
