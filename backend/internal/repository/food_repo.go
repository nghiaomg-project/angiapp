package repository

import (
	"backend/internal/model"
	"context"
)

type FoodRepository interface {
	GetAll(ctx context.Context) ([]model.Food, error)
}

type InMemoryFoodRepository struct {
	foods []model.Food
}

func NewInMemoryFoodRepository() *InMemoryFoodRepository {
	return &InMemoryFoodRepository{
		foods: []model.Food{
			{
				ID:          "1",
				Title:       "Bún Chả Hà Nội",
				Description: "Thịt nướng than hoa thơm lừng, ăn kèm bún rối trắng ngần và nước chấm chua ngọt đậm đà hương vị truyền thống.",
				ImageURL:    "https://lh3.googleusercontent.com/aida-public/AB6AXuCs1q6Yieitc_5768o2jGPhguLqqVCZb6O2VHjY_Ye-9yglzKV1upX8dMtgavabF6VCFwtjpn5z1QWXs0AzUXTD6R4c6IbiDCPN91-30kP0IDRMLu1YuxFcsLV2Fix9xaWRlnJX9Ib6IlI3X_2GSPprSAYtsIr3DP3mmW6evDsevwsr_EO-TeypCcBizOu2aZ0MAg3J2bKiiJZuJWX_lGR3DNdvb3vVm1uVSGNMlegH1jsqLxyiyvrvVloaVDgEb3gX5VnDMWWa1LuL",
				ImageAlt:    "Grilled pork patties with noodles and dipping sauce",
				IsFavorite:  false,
			},
			{
				ID:          "2",
				Title:       "Bánh Xèo Miền Tây",
				Description: "Vỏ bánh vàng ươm giòn rụm, nhân tôm thịt đầy đặn cùng giá đỗ, cuốn rau sống chấm mắm chua ngọt.",
				ImageURL:    "https://lh3.googleusercontent.com/aida-public/AB6AXuBx0E2FjzFsMskL5edfdvFJkPIC8Xgdn01n1StOEWHL5Fr0-UXp4y-urdOunpN-_gZLSLGbmsros977Zotkh_AUx3cqM9w-la0cX8cEVBac7USm1tXl42Nzqr2cLCPffYu5lnXwJNch-2ceRhKNeuE2SPRhmPA200s99_27wx6mwuIoL7CsS2jcTbdXc3xg3A370YPP5_EGAGfX1ppY9KIFuVgEvTvcun8MDaSa81MLMEWdV6esMJClMM1fSJpgiwZ62t_frjNHPz2q",
				ImageAlt:    "Crispy yellow Vietnamese pancake filled with shrimp and sprouts",
				IsFavorite:  true,
			},
			{
				ID:          "3",
				Title:       "Phở Bò Tái Nạm",
				Description: "Nước dùng ngọt thanh từ xương hầm 24h, bánh phở mềm dai và thịt bò tươi ngon thượng hạng.",
				ImageURL:    "https://lh3.googleusercontent.com/aida-public/AB6AXuChsqG0EhDYhWGXH0i17bgKT0qd557VMU5ERoeu7yBe1_XhvzjQQuHVwyiVEsIf8Oc5WiiRa72FG-PBtdSpEtsQbfupdElf7CD3Agybb1NY3f-vMMYcgv3FOnogKV3xlVsOHXxPO4OtNpoWfedSYHqmDsivY9GkWnuuYgY08FnvPOjoZaF4vPSvUwwC1b5mhCPqF6dYlrizATPC5EEtLSku0nwAvl9BwkxWCeMh3YfYeQhaIpPdrYYPgtkng4YZ7uZZMaGB0CGPl-Yq",
				ImageAlt:    "Traditional beef noodle soup in a bowl",
				IsFavorite:  false,
			},
		},
	}
}

func (r *InMemoryFoodRepository) GetAll(ctx context.Context) ([]model.Food, error) {
	return r.foods, nil
}
