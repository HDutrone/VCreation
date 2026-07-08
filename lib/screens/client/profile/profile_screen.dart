import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/gold_divider.dart';
import '../../../models/user_model.dart';
import '../../auth/login_screen.dart';
import '../main_client_screen.dart';
import 'orders_screen.dart';
import 'custom_tracking_screen.dart';
import 'favorites_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) return _GuestProfile();
    return _ClientProfile(user: auth.user!);
  }
}

class _GuestProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Icon(Icons.person_outline,
                    size: 32, color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
              const Text('Pas encore connecté',
                  style: TextStyle(color: AppColors.white, fontSize: 18)),
              const SizedBox(height: 8),
              const Text(
                'Connectez-vous pour accéder à votre espace client, '
                'suivre vos commandes et bien plus.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26)),
                  ),
                  child: const Text('SE CONNECTER',
                      style: TextStyle(
                          color: AppColors.background,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClientProfile extends StatelessWidget {
  final UserModel user;
  const _ClientProfile({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold, width: 1.5),
                ),
                child: Center(
                  child: Text(user.initials,
                      style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 28,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 14),
              Text(user.displayName,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(user.tier,
                  style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      letterSpacing: 2)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.goldFaint,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                ),
                child: Text(
                  'Membre depuis ${user.memberSince}',
                  style: const TextStyle(color: AppColors.gold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 32),
              const GoldDivider(),
              const SizedBox(height: 24),

              // Menu items
              _MenuItem(
                icon: Icons.shopping_bag_outlined,
                title: 'Mes commandes',
                subtitle: '3 commandes',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const OrdersScreen())),
              ),
              _MenuItem(
                icon: Icons.water_drop_outlined,
                title: 'Demandes sur-mesure',
                subtitle: '1 en cours',
                subtitleColor: AppColors.gold,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CustomTrackingScreen())),
              ),
              _MenuItem(
                icon: Icons.favorite_border,
                title: 'Mes favoris',
                subtitle: '5 créations',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen())),
              ),
              _MenuItem(
                icon: Icons.receipt_long_outlined,
                title: 'Paiements & reçus',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.language,
                title: 'Langue',
                trailing: const Text('Français',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
                onTap: () => _showLanguageDialog(context),
              ),
              _MenuItem(
                icon: Icons.help_outline,
                title: 'Centre d\'aide',
                onTap: () {},
              ),
              const SizedBox(height: 8),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout, color: AppColors.error, size: 22),
                title: const Text('Déconnexion',
                    style: TextStyle(color: AppColors.error, fontSize: 16)),
                onTap: () {
                  context.read<AuthProvider>().logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MainClientScreen()),
                    (_) => false,
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Langue', style: TextStyle(color: AppColors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Français', 'English', 'Lingala'].map((lang) {
            return ListTile(
              title: Text(lang, style: const TextStyle(color: AppColors.white)),
              onTap: () => Navigator.pop(ctx),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.subtitleColor,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: AppColors.white, size: 22),
          title: Text(title,
              style: const TextStyle(color: AppColors.white, fontSize: 16)),
          subtitle: subtitle != null
              ? Text(subtitle!,
                  style: TextStyle(
                      color: subtitleColor ?? AppColors.textMuted,
                      fontSize: 12))
              : null,
          trailing: trailing ??
              const Icon(Icons.chevron_right,
                  color: AppColors.textMuted, size: 20),
          onTap: onTap,
        ),
        const Divider(color: AppColors.divider, height: 1),
      ],
    );
  }
}
