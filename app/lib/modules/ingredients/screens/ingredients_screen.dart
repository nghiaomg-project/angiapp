import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/icons/app_icons.dart';
import '../../../core/layouts/main_layout.dart';

// ConvertedUI - Converted from HTML/CSS
class IngredientsScreen extends StatelessWidget {
  const IngredientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5);
    // textMain
    final textMain = isDark ? Colors.white : const Color(0xFF1c1c0d);
    final textMuted = isDark ? Colors.grey[400] : const Color(0xFF9e9d47);
    final surfaceColor = isDark
        ? const Color(0xFF23220f)
        : const Color(0xFFf8f8f5);
    final primaryColor = isDark
        ? const Color(0xFF23220f)
        : const Color(0xFFf8f8f5);
    return MainLayout(
      // title thêm bg
      title: 'Foodie',
      // title: 'Foodie',
      body: Container(
        color: bgColor,
        child: Column(
          children: [
            // Sticky header - converted from <div class="sticky top-0 z-50...">
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bgColor.withOpacity(0.9),
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFF3F4F6),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Back button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // Title
                  Expanded(
                    child: Text(
                      'Tìm Món Từ Nguyên Liệu',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textMain,
                      ),
                    ),
                  ),
                  // Spacer
                  const SizedBox(width: 40),
                ],
              ),
            ),
            // Main content - converted from <main>
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    // Header section - converted from <div class="pt-6 pb-4">
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bạn có gì trong tủ lạnh?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textMain,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Chọn ít nhất 2 nguyên liệu để nhận gợi ý tốt nhất.',
                          style: TextStyle(fontSize: 14, color: textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Search input and Add button row - converted from <div class="flex gap-2 mb-4">
                    Row(
                      children: [
                        // Search input - converted from <div class="relative flex-1">
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Nhập tôm, thịt, trứng...',
                                hintStyle: TextStyle(color: textMuted),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: textMuted,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                filled: true,
                                fillColor: surfaceColor,
                              ),
                              style: TextStyle(color: textMain),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Add button - converted from <button class="bg-surface-light...">
                        Material(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add, size: 18, color: textMain),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Thêm',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: textMain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Selected ingredients chips - converted from <div class="flex flex-wrap gap-2 mb-6">
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _IngredientChip(
                          label: 'Thịt heo',
                          delay: 0,
                          onRemove: () {},
                        ),
                        _IngredientChip(
                          label: 'Cà chua',
                          delay: 50,
                          onRemove: () {},
                        ),
                        _IngredientChip(
                          label: 'Hành lá',
                          delay: 100,
                          onRemove: () {},
                        ),
                        _IngredientChip(
                          label: 'Trứng gà',
                          delay: 150,
                          onRemove: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Search button - converted from <button class="w-full bg-primary...">
                    SizedBox(
                      width: double.infinity,
                      child: Material(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(9999),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(9999),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9999),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.soup_kitchen, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  'Gợi ý món ngay',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Divider - converted from <div class="h-px w-full bg-gray-200...">
                    Container(
                      height: 1,
                      color: isDark
                          ? const Color(0xFF374151)
                          : const Color(0xFFE5E7EB),
                    ),
                    const SizedBox(height: 24),
                    // Section header - converted from <div class="flex items-center justify-between mb-4">
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Món ngon có thể nấu',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textMain,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? surfaceColor
                                    : const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Dễ làm',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? const Color(0xFFD1D5DB)
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? surfaceColor
                                    : const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Nhanh',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? const Color(0xFFD1D5DB)
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Recipe cards - converted from <div class="flex flex-col gap-4">
                    Column(
                      children: [
                        _RecipeCard(
                          imageUrl:
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuB6ndnyyV0aNqW73Y3TMtGF1dihTICarLsDlc2Noy6DiuKW0F7KrT-AxhN0JdF6FYrEXS-Qh7Jt558iGXpIgHpHKipHA2uCERD4Fx5qK_84YQFSu6h47KDlETXj4Dz0JpP6aO9tK-Kn2TB0V2VhtTtC5NqVrB5952ScoMmWYJxIo4mqTKQ_LwqzouRTS0qLQaP8tQ8dxXyjscgZ9B79cDGP7BMyCXjFnfkAzH7qiSUzy8Feh6cYDuCaPmWi1N4Hj3GAJW_DqwjbFYYe',
                          title: 'Canh cà chua trứng',
                          description:
                              'Món canh thanh mát, giải nhiệt cho ngày hè nóng nực.',
                          time: '15p',
                          status: '3/3 Có sẵn',
                          statusColor: Colors.green,
                          isDark: isDark,
                          textMain: textMain,
                          textMuted: textMuted!,
                          surfaceColor: surfaceColor,
                        ),
                        const SizedBox(height: 16),
                        _RecipeCard(
                          imageUrl:
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBz11G9lhThgbG45wwBuOfXiB4xZVlmMrG82yN02ZayBgSN4PDEpLZpFHu9k7dDXlOzrdFOQuIhwpDO2W3EDGiIIlGVULLw3T85WgguA-dfrXrtd9FRKWS8gyJgUJ7yvHE8vHbzq3W11vVgjPJw0LLp2c3AIOLfNTCkiFRoyGdeX57-wXqF4Z7Kgl-fwipcJBzwDhc4Tu2GMvXuS4TB9T4IIzrUKf6Rml7wdoqN1WkjiucgyrLbRno9i-UwOtidYTmwMBQP7q9wsAeo',
                          title: 'Thịt heo sốt cà chua',
                          description:
                              'Đậm đà đưa cơm, thích hợp cho bữa tối gia đình.',
                          time: '25p',
                          status: '2/2 Có sẵn',
                          statusColor: Colors.green,
                          isDark: isDark,
                          textMain: textMain,
                          textMuted: textMuted!,
                          surfaceColor: surfaceColor,
                        ),
                        const SizedBox(height: 16),
                        _RecipeCard(
                          imageUrl:
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuCEJKZ6auC-fgaH5bIg03nFH49qs21FH18220JnooKEkvzhx3jcb8xQ7xUg2b_GZUuyVBSjnvhTO1Xwh6_uHXUnRr6ofpz2dttg_FjtM5GZRbqnA7rxrlps5a2qPGK_Z1SHTDmySuYGjtvOcgBfiKW-UEO8CQ2vesla75sr4281gOOpVSl7xfHEN0-8lvTCmgewUGyFWx_9cJsssOVq0TdVk-tBeqFsbB_pA9fsA3w5xCO9KSs70yLLA8vA_d--1b6i_bVyiyyfl2cj',
                          title: 'Trứng chiên hành tây',
                          description:
                              'Cần thêm hành tây để hoàn thành món này.',
                          time: '10p',
                          status: 'Thiếu 1',
                          statusColor: Colors.orange,
                          isDark: isDark,
                          textMain: textMain,
                          textMuted: textMuted,
                          surfaceColor: surfaceColor,
                          opacity: 0.8,
                        ),
                      ],
                    ),
                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ingredient chip widget - converted from ingredient chips in HTML
class _IngredientChip extends StatelessWidget {
  final String label;
  final int delay;
  final VoidCallback onRemove;

  const _IngredientChip({
    required this.label,
    required this.delay,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF7A00),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4),
            Material(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Recipe card widget - converted from recipe cards in HTML
class _RecipeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String time;
  final String status;
  final Color statusColor;
  final bool isDark;
  final Color textMain;
  final Color textMuted;
  final Color surfaceColor;
  final double opacity;

  const _RecipeCard({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.isDark,
    required this.textMain,
    required this.textMuted,
    required this.surfaceColor,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF374151) : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 96,
                height: 96,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 96,
                    height: 96,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textMain,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: textMuted),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Time
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 14, color: textMuted),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              color: textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor == Colors.green
                              ? (isDark
                                    ? Colors.green.withOpacity(0.2)
                                    : const Color(0xFFF0FDF4))
                              : (isDark
                                    ? Colors.orange.withOpacity(0.2)
                                    : const Color(0xFFFFF7ED)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              statusColor == Colors.green
                                  ? Icons.check_circle
                                  : Icons.timelapse,
                              size: 14,
                              color: statusColor == Colors.green
                                  ? (isDark
                                        ? Colors.green[300]
                                        : Colors.green[700])
                                  : (isDark
                                        ? Colors.orange[300]
                                        : Colors.orange[700]),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: statusColor == Colors.green
                                    ? (isDark
                                          ? Colors.green[300]
                                          : Colors.green[700])
                                    : (isDark
                                          ? Colors.orange[300]
                                          : Colors.orange[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Bottom navigation item widget
class _BottomNavItem extends StatelessWidget {
  final HeroIcons icon;
  final String label;
  final bool isActive;
  final bool isSpecial;
  final VoidCallback onTap;
  final bool isDark;
  final Color textMain;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    this.isSpecial = false,
    required this.onTap,
    required this.isDark,
    required this.textMain,
  });

  @override
  Widget build(BuildContext context) {
    if (isSpecial && isActive) {
      // Special orange circle for search tab when active
      return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: const Offset(0, -32),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A00),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF23220f)
                        : const Color(0xFFf8f8f5),
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: HeroIcon(AppIcons.search, color: Colors.white, size: 24),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: textMain,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroIcon(
            icon,
            color: isActive ? textMain : const Color(0xFF9CA3AF),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? textMain : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}
