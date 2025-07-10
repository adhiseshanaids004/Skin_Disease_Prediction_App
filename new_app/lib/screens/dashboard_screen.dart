import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/dashboard_button.dart';
import '../widgets/profile_card.dart';
import '../widgets/health_summary.dart';
import '../widgets/health_tip_carousel.dart';
import '../widgets/emergency_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'app_name'.tr(),
          style: GoogleFonts.poppins(
            color: theme.appBarTheme.titleTextStyle?.color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: colors.primary.withOpacity(0.2),
              child: const Icon(Icons.person, color: Colors.blueGrey),
            ),
            onSelected: (value) async {
              if (value == 'profile') {
                Navigator.pushNamed(context, '/profile');
              } else if (value == 'logout') {
                await authService.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context, 
                    '/login', 
                    (route) => false,
                  );
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 20),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const ProfileCard(userName: 'Adhi'),
              const SizedBox(height: 24),
              Text(
                'quick_access'.tr(),
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: isTablet ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
                children: [
                  DashboardButton(
                    icon: Icons.camera_alt,
                    title: 'scan_now'.tr(),
                    color: colors.primary,
                    onTap: () {
                      Navigator.pushNamed(context, '/scan');
                    },
                  ),
                  DashboardButton(
                    icon: Icons.history,
                    title: 'history'.tr(),
                    color: colors.secondary,
                    onTap: () {
                      Navigator.pushNamed(context, '/history');
                    },
                  ),
                  DashboardButton(
                    icon: Icons.chat,
                    title: 'chatbot'.tr(),
                    color: colors.tertiary ?? colors.secondaryContainer,
                    onTap: () {
                      Navigator.pushNamed(context, '/chat');
                    },
                  ),
                  DashboardButton(
                    icon: Icons.settings,
                    title: 'settings'.tr(),
                    color: colors.primaryContainer,
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const HealthSummary(),
              const SizedBox(height: 24),
              Text(
                'health_tips'.tr(),
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              const HealthTipCarousel(),
              const SizedBox(height: 24),
              const EmergencyCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}