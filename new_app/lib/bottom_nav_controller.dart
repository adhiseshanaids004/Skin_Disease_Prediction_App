import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:skin_sense/screens/chatbot_screen.dart';
import 'package:skin_sense/screens/dashboard_screen.dart';
import 'package:skin_sense/screens/history_screen.dart';
import 'package:skin_sense/screens/scan_screen.dart';
import 'package:skin_sense/screens/settings_screen.dart';

class BottomNavController extends StatefulWidget {
  const BottomNavController({super.key});

  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardScreen(
        onNavItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      const ScanScreen(),
      HistoryScreen(),
      const ChatBotScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Theme(
            data: theme.copyWith(
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: theme.cardColor,
                selectedItemColor: theme.colorScheme.secondary,
                unselectedItemColor: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
                type: BottomNavigationBarType.fixed,
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  activeIcon: const Icon(Icons.home),
                  label: 'home'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.camera_alt_outlined),
                  activeIcon: const Icon(Icons.camera_alt),
                  label: 'scan'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.history_outlined),
                  activeIcon: const Icon(Icons.history),
                  label: 'history'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.chat_bubble_outline),
                  activeIcon: const Icon(Icons.chat_bubble),
                  label: 'chat'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings_outlined),
                  activeIcon: const Icon(Icons.settings),
                  label: 'settings'.tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
