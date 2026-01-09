import 'package:flutter/material.dart';
import '../../../core/layouts/main_layout.dart';
import '../../../core/auth/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_authService.isLoggedIn) {
        _authService.setPendingRoute('/profile');
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFF7A00);

    final googleUser = _authService.currentUser;
    final backendUser = _authService.backendUser;

    final displayName = backendUser?['name'] ?? googleUser?.displayName ?? 'Chưa đặt tên';
    final email = backendUser?['email'] ?? googleUser?.email ?? 'Chưa có email';
    final String? backendAvatar = backendUser?['avatar_url'];
    final photoUrl = (backendAvatar != null && backendAvatar.isNotEmpty) 
        ? backendAvatar 
        : googleUser?.photoUrl;
    
    final favoritesCount = backendUser?['favorites_count']?.toString() ?? '0';
    final recipesCount = backendUser?['recipes_count']?.toString() ?? '0';

    if (!_authService.isLoggedIn) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return MainLayout(
      title: 'Hồ Sơ',
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            // Profile Header
            const SizedBox(height: 16),
            _buildAvatarSection(primaryColor, photoUrl),
            const SizedBox(height: 16),
            
            // Name and Email
            Text(
              displayName,
              style: const TextStyle(
                fontFamily: 'Spline Sans',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1C0D), // slate-900
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
            
            // Verified Badge
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, size: 18, color: Colors.orange[600]),
                  const SizedBox(width: 6),
                  Text(
                    'THÀNH VIÊN GOOGLE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700],
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Stats
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatCard(favoritesCount, 'Yêu thích'),
                const SizedBox(width: 12),
                _buildStatCard(recipesCount, 'Công thức'),
              ],
            ),

            // Spacer to push content down if needed, 
            // but in ScrollView we just add space
            const SizedBox(height: 80),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  AuthService().logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 8,
                  shadowColor: primaryColor.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Đăng xuất',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            // Version
            const SizedBox(height: 24),
            Text(
              'Phiên bản 2.4.0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection(Color primaryColor, String? photoUrl) {
    return Stack(
      children: [
        Container(
          width: 128,
          height: 128,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                primaryColor,
                Colors.orange[300]!,
              ],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF8F8F5), width: 4),
              color: Colors.grey[200],
              image: photoUrl != null 
                  ? DecorationImage(
                      image: NetworkImage(photoUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: photoUrl == null 
                ? Icon(Icons.person, size: 64, color: Colors.grey[400])
                : null,
          ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.grey[100]!),
            ),
             child: const Text('G', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 18, fontFamily: 'sans-serif')),
          ),
        )
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      width: 112,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C1C0D),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
