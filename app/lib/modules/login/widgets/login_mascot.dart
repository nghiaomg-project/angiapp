import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/icons/app_icons.dart';

class LoginMascot extends StatefulWidget {
  const LoginMascot({super.key});

  @override
  State<LoginMascot> createState() => _LoginMascotState();
}

class _LoginMascotState extends State<LoginMascot>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF3a392a) : Colors.white;
    final ringColor = isDark ? const Color(0xFF3a392a) : Colors.white;

    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 192,
            height: 192,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ringColor, width: 4),
                color: bgColor,
              ),
              child: ClipOval(
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAZ5zNjfZepUfmQdXf7whYUKY8fgpuseP0UwR8mrETg0Tb6ohNAxzJ5amOjkRcDZo7uJRRc_8W77mC3Ux3a3PnqL7ZWkFoCYsb-7NDaC5V5-yrl_UsSRJ2m70KeJdRPg7wMpHsiNTY98g0VhcWvNxhJOu7Lu32S4aZNF5cmGZQYFClGrsmA3bA8RtsnoFwxgciVZcYczwDB8mu428qJm_i09AzP9t1qvyZ2MFsuCPmphxIoqN2-7-48TjNEFkNdiY4YzPDhDIimXVFC',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: bgColor,
                      child: const Icon(Icons.restaurant, size: 80),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 40,
            child: AnimatedBuilder(
              animation: _bounceController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _bounceController.value * 8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: HeroIcon(
                      AppIcons.restaurant,
                      color: const Color(0xFFFF7A00),
                      size: 24,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            bottom: 16,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.7 + (_pulseController.value * 0.3),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const HeroIcon(
                      HeroIcons.sparkles,
                      color: Color(0xFF4CAF50),
                      size: 24,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
