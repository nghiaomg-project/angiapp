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
			Title:       "Phở Bò Nam Định",
			Description: "Món phở truyền thống với nước dùng đậm đà, thịt bò mềm và bánh phở tươi.",
			ImageURL:    "https://cdn.tgdd.vn/Files/2022/01/25/1412805/cach-nau-pho-bo-nam-dinh-chuan-vi-thom-ngon-nhu-hang-quan-202201250230038502.jpg",
			ImageAlt:    "Bát phở bò nóng hổi",
			IsFavorite:  false,
			Time:        "45 phút",
			Difficulty:  "Trung bình",
			Servings:    "2 người",
			Ingredients: []model.Ingredient{
				{Name: "Thịt bò", Amount: "500g"},
				{Name: "Bánh phở", Amount: "500g"},
				{Name: "Hành tây", Amount: "1 củ"},
				{Name: "Gừng", Amount: "1 củ"},
				{Name: "Gia vị phở", Amount: "1 gói"},
			},
			Steps: []model.Step{
				{Index: 1, Title: "Sơ chế nguyên liệu", Description: "Rửa sạch thịt bò, thái lát mỏng. Hành tây thái mỏng, gừng nướng sơ."},
				{Index: 2, Title: "Nấu nước dùng", Description: "Hầm xương bò với gừng, hành tây và gia vị phở trong 30 phút."},
				{Index: 3, Title: "Hoàn thiện", Description: "Trụng bánh phở, xếp thịt bò lên trên và chan nước dùng nóng."},
			},
		},
		{
			ID:          primitive.NewObjectID().Hex(),
			Title:       "Bún Chả Hà Nội",
			Description: "Thịt nướng than hoa thơm lừng, ăn kèm bún rối trắng ngần và nước chấm chua ngọt đậm đà hương vị truyền thống.",
			ImageURL:    "https://cdn.zsoft.solutions/poseidon-web/app/media/uploaded-files/090724-bun-cha-ha-noi-buffet-poseidon-1.jpeg",
			ImageAlt:    "Mẹt bún chả hấp dẫn",
			IsFavorite:  true,
			Time:        "60 phút",
			Difficulty:  "Khó",
			Servings:    "4 người",
			Ingredients: []model.Ingredient{
				{Name: "Thịt ba chỉ", Amount: "500g"},
				{Name: "Thịt nạc vai", Amount: "300g"},
				{Name: "Bún tươi", Amount: "1kg"},
				{Name: "Đu đủ xanh", Amount: "1/2 quả"},
				{Name: "Cà rốt", Amount: "1 củ"},
			},
			Steps: []model.Step{
				{Index: 1, Title: "Ướp thịt", Description: "Thái thịt miếng vừa ăn, ướp với nước mắm, hành tím, tiêu, đường trong 30 phút."},
				{Index: 2, Title: "Nướng thịt", Description: "Nướng thịt trên than hoa cho đến khi vàng đều và thơm."},
				{Index: 3, Title: "Pha nước chấm", Description: "Pha nước mắm chua ngọt với đu đủ, cà rốt tỉa hoa."},
			},
		},
		{
			ID:          primitive.NewObjectID().Hex(),
			Title:       "Bánh Xèo Miền Tây",
			Description: "Vỏ bánh vàng ươm giòn rụm, nhân tôm thịt đầy đặn cùng giá đỗ, cuốn rau sống chấm mắm chua ngọt.",
			ImageURL:    "https://i-giadinh.vnecdn.net/2023/09/19/Buoc-10-Thanh-pham-1-1-5225-1695107554.jpg",
			ImageAlt:    "Bánh xèo vàng giòn",
			IsFavorite:  true,
			Time:        "45 phút",
			Difficulty:  "Dễ",
			Servings:    "4 cái",
			Ingredients: []model.Ingredient{
				{Name: "Bột bánh xèo", Amount: "1 gói"},
				{Name: "Tôm tươi", Amount: "300g"},
				{Name: "Thịt ba chỉ", Amount: "300g"},
				{Name: "Giá đỗ", Amount: "200g"},
				{Name: "Rau sống", Amount: "500g"},
			},
			Steps: []model.Step{
				{Index: 1, Title: "Pha bột", Description: "Pha bột bánh xèo với nước, nước cốt dừa và hành lá cắt nhỏ."},
				{Index: 2, Title: "Đổ bánh", Description: "Đổ bột vào chảo nóng, thêm nhân tôm thịt, đậy nắp chờ chín."},
				{Index: 3, Title: "Thưởng thức", Description: "Cuốn bánh với rau sống và bánh tráng, chấm mắm chua ngọt."},
			},
		},
		{
			ID:          primitive.NewObjectID().Hex(),
			Title:       "Phở Bò Tái Nạm",
			Description: "Nước dùng ngọt thanh từ xương hầm 24h, bánh phở mềm dai và thịt bò tươi ngon thượng hạng.",
			ImageURL:    "https://lh7-us.googleusercontent.com/tKrb4KxuhIiX9PEYqPZsn2zbShiqha4iT03pSJsAk5KJrtc0sCxTGepjfagPkQWiHix6DkwYucMsAnocuSqVpVO-dtP8PD55pM8sJHZhu0EmBc8zpjz054TRFl4U0qLjo4yBeVeZAbPar1bZ41yZpIc",
			ImageAlt:    "Bát phở tái nạm",
			IsFavorite:  false,
			Time:        "3 giờ",
			Difficulty:  "Khó",
			Servings:    "6 người",
			Ingredients: []model.Ingredient{
				{Name: "Xương ống bò", Amount: "2kg"},
				{Name: "Thịt bò tái/nạm", Amount: "1kg"},
				{Name: "Bánh phở", Amount: "1.5kg"},
				{Name: "Gia vị phở", Amount: "1 gói"},
			},
			Steps: []model.Step{
				{Index: 1, Title: "Ninh nước dùng", Description: "Ninh xương với 5 lít nước trong 3-4 tiếng."},
				{Index: 2, Title: "Chuẩn bị thịt", Description: "Thịt nạm luộc chín, thịt tái thái mỏng."},
				{Index: 3, Title: "Hoàn thiện", Description: "Chần bánh phở, thêm thịt và chan nước dùng."},
			},
		},
		{
			ID:          primitive.NewObjectID().Hex(),
			Title:       "Gỏi Cuốn Tôm Thịt",
			Description: "Món khai vị thanh mát, dễ làm với tôm, thịt heo và rau sống.",
			ImageURL:    "https://cdn.netspace.edu.vn/images/2020/04/25/cach-lam-goi-cuon-tom-thit-cuc-ki-hap-dan-245587-800.jpg",
			ImageAlt:    "Đĩa gỏi cuốn tôm thịt",
			IsFavorite:  false,
			Time:        "30 phút",
			Difficulty:  "Dễ",
			Servings:    "3 người",
			Ingredients: []model.Ingredient{
				{Name: "Tôm tươi", Amount: "300g"},
				{Name: "Thịt ba chỉ", Amount: "300g"},
				{Name: "Bánh tráng", Amount: "1 gói"},
				{Name: "Bún tươi", Amount: "300g"},
				{Name: "Rau sống", Amount: "200g"},
			},
			Steps: []model.Step{
				{Index: 1, Title: "Luộc tôm thịt", Description: "Luộc chín tôm và thịt, sau đó thái lát mỏng."},
				{Index: 2, Title: "Cuốn gỏi", Description: "Làm ướt bánh tráng, xếp rau, bún, tôm, thịt lên và cuốn chặt tay."},
				{Index: 3, Title: "Pha tương chấm", Description: "Pha tương hột với bơ đậu phộng và tỏi phi."},
			},
		},
		{
			ID:          primitive.NewObjectID().Hex(),
			Title:       "Cơm Tấm Sườn Bì Chả",
			Description: "Món ăn sáng quen thuộc của người Sài Gòn với sườn nướng mật ong.",
			ImageURL:    "https://i-giadinh.vnecdn.net/2024/03/07/7Honthinthnhphm1-1709800144-8583-1709800424.jpg",
			ImageAlt:    "Đĩa cơm tấm đầy đặn",
			IsFavorite:  true,
			Time:        "50 phút",
			Difficulty:  "Trung bình",
			Servings:    "4 người",
			Ingredients: []model.Ingredient{
				{Name: "Gạo tấm", Amount: "500g"},
				{Name: "Sườn cốt lết", Amount: "4 miếng"},
				{Name: "Bì heo", Amount: "200g"},
				{Name: "Trứng gà", Amount: "4 quả"},
				{Name: "Mỡ hành", Amount: "1 bát nhỏ"},
			},
			Steps: []model.Step{
				{Index: 1, Title: "Nấu cơm", Description: "Vo sạch gạo tấm và nấu chín bằng nồi cơm điện."},
				{Index: 2, Title: "Nướng sườn", Description: "Ướp sườn với mật ong, nước tương, tỏi rồi nướng chín."},
				{Index: 3, Title: "Làm chả trứng", Description: "Đánh trứng với thịt băm, nấm mèo, bún tàu rồi hấp chín."},
			},
		},
		{
			ID:          primitive.NewObjectID().Hex(),
			Title:       "Bánh Mì Chảo",
			Description: "Bữa sáng năng lượng với trứng ốp la, pate và xúc xích nóng hổi.",
			ImageURL:    "https://www.huongnghiepaau.com/wp-content/uploads/2022/06/banh-mi-chao.jpg",
			ImageAlt:    "Chảo bánh mì nóng hổi",
			IsFavorite:  false,
			Time:        "15 phút",
			Difficulty:  "Dễ",
			Servings:    "1 người",
			Ingredients: []model.Ingredient{
				{Name: "Bánh mì", Amount: "1 ổ"},
				{Name: "Trứng gà", Amount: "1 quả"},
				{Name: "Pate gan", Amount: "50g"},
				{Name: "Xúc xích", Amount: "1 cây"},
				{Name: "Hành tây", Amount: "1/4 củ"},
			},
			Steps: []model.Step{
				{Index: 1, Title: "Chiên trứng", Description: "Đun nóng chảo dầu, ốp la trứng gà."},
				{Index: 2, Title: "Thêm topping", Description: "Cho pate, xúc xích và hành tây vào chảo đảo sơ."},
				{Index: 3, Title: "Thưởng thức", Description: "Ăn kèm bánh mì nóng chấm với nước sốt trong chảo."},
			},
		},
		{
			ID:          primitive.NewObjectID().Hex(),
			Title:       "Canh Chua Cá Lóc",
			Description: "Món canh dân dã miền Tây với vị chua ngọt hài hòa.",
			ImageURL:    "https://i-giadinh.vnecdn.net/2023/04/25/Thanh-pham-1-1-7239-1682395675.jpg",
			ImageAlt:    "Tô canh chua cá lóc",
			IsFavorite:  true,
			Time:        "40 phút",
			Difficulty:  "Trung bình",
			Servings:    "4 người",
			Ingredients: []model.Ingredient{
				{Name: "Cá lóc", Amount: "1 con (500g)"},
				{Name: "Bạc hà", Amount: "2 cây"},
				{Name: "Đậu bắp", Amount: "100g"},
				{Name: "Thơm (Dứa)", Amount: "1/4 trái"},
				{Name: "Me chua", Amount: "50g"},
			},
			Steps: []model.Step{
				{Index: 1, Title: "Sơ chế cá", Description: "Làm sạch cá lóc, cắt khúc vừa ăn."},
				{Index: 2, Title: "Nấu nước canh", Description: "Đun sôi nước, lọc me lấy nước cốt, cho cá vào nấu chín."},
				{Index: 3, Title: "Thêm rau", Description: "Cho thơm, đậu bắp, bạc hà vào nấu chín tới, nêm nếm gia vị."},
			},
		},
		{
			ID:          primitive.NewObjectID().Hex(),
			Title:       "Thịt Kho Tàu",
			Description: "Món ăn truyền thống ngày Tết với thịt kho mềm rục và trứng vịt.",
			ImageURL:    "https://file.hstatic.net/200000700229/article/thit-kho-tau-thumb_bc66044baa614c3ba455a1fcd7b1413a.jpg",
			ImageAlt:    "Nồi thịt kho tàu",
			IsFavorite:  false,
			Time:        "120 phút",
			Difficulty:  "Trung bình",
			Servings:    "6 người",
			Ingredients: []model.Ingredient{
				{Name: "Thịt ba chỉ", Amount: "1kg"},
				{Name: "Trứng vịt", Amount: "10 quả"},
				{Name: "Nước dừa tươi", Amount: "1 lít"},
				{Name: "Hành tím", Amount: "5 củ"},
				{Name: "Nước mắm", Amount: "1/2 bát"},
			},
			Steps: []model.Step{
				{Index: 1, Title: "Ướp thịt", Description: "Thái thịt miếng to, ướp với hành tím băm và gia vị."},
				{Index: 2, Title: "Kho thịt", Description: "Xào săn thịt, đổ nước dừa vào kho lửa nhỏ."},
				{Index: 3, Title: "Thêm trứng", Description: "Luộc trứng vịt, bóc vỏ, cho vào nồi kho cùng thịt đến khi nước keo lại."},
			},
		},
		{
			ID:          primitive.NewObjectID().Hex(),
			Title:       "Mì Xào Bò",
			Description: "Bữa trưa nhanh gọn với mì tôm xào thịt bò và cải ngọt.",
			ImageURL:    "https://i-giadinh.vnecdn.net/2022/07/30/Thanh-pham-1-1-2409-1659167237.jpg",
			ImageAlt:    "Đĩa mì xào bò",
			IsFavorite:  false,
			Time:        "20 phút",
			Difficulty:  "Dễ",
			Servings:    "1 người",
			Ingredients: []model.Ingredient{
				{Name: "Mì tôm", Amount: "2 gói"},
				{Name: "Thịt bò", Amount: "100g"},
				{Name: "Cải ngọt", Amount: "1 bó nhỏ"},
				{Name: "Tỏi", Amount: "3 tép"},
			},
			Steps: []model.Step{
				{Index: 1, Title: "Trụng mì", Description: "Trụng sơ mì qua nước sôi rồi vớt ra để ráo."},
				{Index: 2, Title: "Xào bò", Description: "Phi thơm tỏi, xào thịt bò tái rồi để riêng."},
				{Index: 3, Title: "Xào mì", Description: "Xào cải ngọt, cho mì và thịt bò vào đảo đều, nêm gia vị."},
			},
		},
		{
			ID:          primitive.NewObjectID().Hex(),
			Title:       "Chè Bưởi",
			Description: "Món tráng miệng ngọt thanh, giòn dai hấp dẫn.",
			ImageURL:    "https://file.hstatic.net/200000721249/file/che_buoi_d13d44779d7d4a6ea7b5881361285169.jpg",
			ImageAlt:    "Ly chè bưởi",
			IsFavorite:  true,
			Time:        "90 phút",
			Difficulty:  "Khó",
			Servings:    "5 người",
			Ingredients: []model.Ingredient{
				{Name: "Cùi bưởi", Amount: "1 quả"},
				{Name: "Đậu xanh", Amount: "200g"},
				{Name: "Bột năng", Amount: "100g"},
				{Name: "Nước cốt dừa", Amount: "200ml"},
				{Name: "Đường thốt nốt", Amount: "200g"},
			},
			Steps: []model.Step{
				{Index: 1, Title: "Sơ chế cùi bưởi", Description: "Cắt hạt lựu, bóp muối xả nhiều lần cho hết đắng."},
				{Index: 2, Title: "Luộc cùi bưởi", Description: "Áo bột năng luộc cùi bưởi đến khi trong."},
				{Index: 3, Title: "Nấu chè", Description: "Nấu đậu xanh chín, thêm đường, bột năng tạo độ sánh rồi thả cùi bưởi vào."},
			},
		},
		{
			ID:          primitive.NewObjectID().Hex(),
			Title:       "Salad Nga",
			Description: "Món salad trộn rau củ quả bổ dưỡng.",
			ImageURL:    "https://kombo.vn/medias/2022/11/salad-nga-chay-thom-ngon-kombo.png",
			ImageAlt:    "Bát salad nga",
			IsFavorite:  false,
			Time:        "30 phút",
			Difficulty:  "Dễ",
			Servings:    "4 người",
			Ingredients: []model.Ingredient{
				{Name: "Khoai tây", Amount: "2 củ"},
				{Name: "Cà rốt", Amount: "1 củ"},
				{Name: "Dưa leo", Amount: "1 quả"},
				{Name: "Trứng gà", Amount: "2 quả"},
				{Name: "Sốt mayonnaise", Amount: "100g"},
			},
			Steps: []model.Step{
				{Index: 1, Title: "Luộc rau củ", Description: "Luộc chín khoai tây, cà rốt, trứng gà rồi thái hạt lựu."},
				{Index: 2, Title: "Sơ chế dưa leo", Description: "Thái hạt lựu dưa leo và các nguyên liệu khác."},
				{Index: 3, Title: "Trộn salad", Description: "Trộn đều tất cả nguyên liệu với sốt mayonnaise."},
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
