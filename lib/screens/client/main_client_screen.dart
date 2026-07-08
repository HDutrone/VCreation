import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/whatsapp_fab.dart';
import 'home/home_screen.dart';
import 'collections/collections_screen.dart';
import 'sur_mesure/sur_mesure_screen.dart';
import 'cart/cart_screen.dart';
import 'profile/profile_screen.dart';

class MainClientScreen extends StatefulWidget {
  final int initialIndex;
  const MainClientScreen({super.key, this.initialIndex = 0});

  @override
  State<MainClientScreen> createState() => _MainClientScreenState();
}

class _MainClientScreenState extends State<MainClientScreen> {
  late int _currentIndex;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _screens = [
      HomeScreen(onNavigateToTab: (i) => setState(() => _currentIndex = i)),
      const CollectionsScreen(),
      const SurMesureScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: _screens),
      floatingActionButton: _currentIndex != 0 ? const WhatsAppFab() : null,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil'),
        BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Collections'),
        BottomNavigationBarItem(
            icon: _SurMesureIcon(active: false),
            activeIcon: _SurMesureIcon(active: true),
            label: 'Sur-Mesure'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Panier'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil'),
      ],
    );
  }
}

class _SurMesureIcon extends StatelessWidget {
  final bool active;
  const _SurMesureIcon({required this.active});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.water_drop_outlined,
        color: active ? AppColors.gold : AppColors.textMuted);
  }
}
