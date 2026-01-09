import 'package:flutter/material.dart';
import '../../../core/layouts/main_layout.dart';
import '../widgets/food_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1c1c0d);
    final textSecondary = isDark ? Colors.grey[400] : const Color(0xFF9e9d47);

    return MainLayout(
      // title thêm bg
      title: 'Foodie',
      // title: 'Foodie',
      body: Container(
        color: bgColor,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 24),
                    child: Text(
                      'Hôm nay bạn muốn ăn gì?',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  FoodCard(
                    title: 'Bún Chả Hà Nội',
                    description:
                        'Thịt nướng than hoa thơm lừng, ăn kèm bún rối trắng ngần và nước chấm chua ngọt đậm đà hương vị truyền thống.',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCs1q6Yieitc_5768o2jGPhguLqqVCZb6O2VHjY_Ye-9yglzKV1upX8dMtgavabF6VCFwtjpn5z1QWXs0AzUXTD6R4c6IbiDCPN91-30kP0IDRMLu1YuxFcsLV2Fix9xaWRlnJX9Ib6IlI3X_2GSPprSAYtsIr3DP3mmW6evDsevwsr_EO-TeypCcBizOu2aZ0MAg3J2bKiiJZuJWX_lGR3DNdvb3vVm1uVSGNMlegH1jsqLxyiyvrvVloaVDgEb3gX5VnDMWWa1LuL',
                    imageAlt:
                        'Grilled pork patties with noodles and dipping sauce',
                    isFavorite: false,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Xem công thức: Bún Chả Hà Nội'),
                        ),
                      );
                    },
                  ),
                  FoodCard(
                    title: 'Bánh Xèo Miền Tây',
                    description:
                        'Vỏ bánh vàng ươm giòn rụm, nhân tôm thịt đầy đặn cùng giá đỗ, cuốn rau sống chấm mắm chua ngọt.',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBx0E2FjzFsMskL5edfdvFJkPIC8Xgdn01n1StOEWHL5Fr0-UXp4y-urdOunpN-_gZLSLGbmsros977Zotkh_AUx3cqM9w-la0cX8cEVBac7USm1tXl42Nzqr2cLCPffYu5lnXwJNch-2ceRhKNeuE2SPRhmPA200s99_27wx6mwuIoL7CsS2jcTbdXc3xg3A370YPP5_EGAGfX1ppY9KIFuVgEvTvcun8MDaSa81MLMEWdV6esMJClMM1fSJpgiwZ62t_frjNHPz2q',
                    imageAlt:
                        'Crispy yellow Vietnamese pancake filled with shrimp and sprouts',
                    isFavorite: true,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Xem công thức: Bánh Xèo Miền Tây'),
                        ),
                      );
                    },
                  ),
                  FoodCard(
                    title: 'Phở Bò Tái Nạm',
                    description:
                        'Nước dùng ngọt thanh từ xương hầm 24h, bánh phở mềm dai và thịt bò tươi ngon thượng hạng.',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuChsqG0EhDYhWGXH0i17bgKT0qd557VMU5ERoeu7yBe1_XhvzjQQuHVwyiVEsIf8Oc5WiiRa72FG-PBtdSpEtsQbfupdElf7CD3Agybb1NY3f-vMMYcgv3FOnogKV3xlVsOHXxPO4OtNpoWfedSYHqmDsivY9GkWnuuYgY08FnvPOjoZaF4vPSvUwwC1b5mhCPqF6dYlrizATPC5EEtLSku0nwAvl9BwkxWCeMh3YfYeQhaIpPdrYYPgtkng4YZ7uZZMaGB0CGPl-Yq',
                    imageAlt: 'Traditional beef noodle soup in a bowl',
                    isFavorite: false,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Xem công thức: Phở Bò Tái Nạm'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTapDown: (_) {},
                  onTapUp: (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gợi ý món mới')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7A00),
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF7A00).withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.autorenew,
                          color: Color(0xFF1c1c0d),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Gợi ý món mới',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
