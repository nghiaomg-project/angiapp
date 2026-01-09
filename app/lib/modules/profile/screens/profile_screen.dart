import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/layouts/main_layout.dart';
import '../../../core/icons/app_icons.dart';
import '../widgets/profile_info_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Profile',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: HeroIcon(
                AppIcons.user,
                size: 60,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'John Doe',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Food Enthusiast',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            const ProfileInfoTile(
              icon: AppIcons.email,
              label: 'Email',
              value: 'john.doe@example.com',
            ),
            const SizedBox(height: 12),
            const ProfileInfoTile(
              icon: AppIcons.phone,
              label: 'Phone',
              value: '+1 234 567 8900',
            ),
            const SizedBox(height: 12),
            const ProfileInfoTile(
              icon: AppIcons.location,
              label: 'Address',
              value: '123 Main Street, City',
            ),
            const SizedBox(height: 12),
            const ProfileInfoTile(
              icon: AppIcons.calendar,
              label: 'Member Since',
              value: 'January 2024',
            ),
          ],
        ),
      ),
    );
  }
}

