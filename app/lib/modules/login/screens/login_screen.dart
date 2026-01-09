import 'package:flutter/material.dart';
import '../../../core/auth/auth_guard.dart';
import '../../../core/auth/auth_service.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/login_mascot.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1c1c0d);
    final textSecondary = isDark
        ? const Color(0xFFd1d1c0)
        : const Color(0xFF4a4a40);
    final textTertiary = isDark
        ? const Color(0xFF66665c)
        : const Color(0xFF8c8c80);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight * 0.65,
                      child: Stack(
                        children: [
                          Positioned(
                            top: constraints.maxHeight * 0.15,
                            left: MediaQuery.of(context).size.width * 0.5 - 118,
                            child: Container(
                              width: 236,
                              height: 236,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(
                                  0xFFFF7A00,
                                ).withValues(alpha: isDark ? 0.1 : 0.2),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFFF7A00,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 80,
                                      spreadRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 115),
                                const LoginMascot(),
                                const SizedBox(height: 32),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Chào mừng bạn!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: textPrimary,
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          height: 1.2,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Tìm kiếm món ngon & công thức nấu ăn mỗi ngày.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: textSecondary,
                                          fontSize: 17,
                                          fontWeight: FontWeight.normal,
                                          height: 1.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          GoogleSignInButton(
                            onPressed: () {
                              AuthService().login();
                              AuthGuard.navigateAfterLogin(context);
                            },
                          ),
                          // const SizedBox(height: 24),
                          // Expanded(child: Container(color: Colors.red)),
                          TextButton(
                            onPressed: () {
                              AuthGuard.navigate(context, '/home');
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                              minimumSize: const Size(0, 40),
                            ),
                            child: Text(
                              'Bỏ qua',
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
