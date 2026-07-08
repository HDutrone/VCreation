import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/product_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/orders_provider.dart';
import '../../../providers/products_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../widgets/app_image.dart';
import '../../../widgets/gold_divider.dart';
import '../../client/main_client_screen.dart';

class DashboardScreen extends StatelessWidget {
  final void Function(int)? onTabSwitch;
  const DashboardScreen({super.key, this.onTabSwitch});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>();
    final products = context.watch<ProductsProvider>();

    final totalViews = products.products.fold<int>(0, (s, p) => s + p.viewCount);
    final totalOrders = orders.orders.length;
    final surMesure = orders.customRequests.length;
    final pending = orders.newOrders.length +
        orders.customRequests.where((r) => r.status.name == 'nouvelle').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Admin action bar
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('BIENVENUE',
                            style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                                letterSpacing: 3)),
                        Text('Tableau de bord',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(fontSize: 28)),
                      ],
                    ),
                  ),
                  _AdminBtn(
                    icon: Icons.home_outlined,
                    label: 'Accueil',
                    onTap: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainClientScreen()),
                      (_) => false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _AdminBtn(
                    icon: Icons.logout,
                    label: 'Quitter',
                    color: AppColors.error,
                    onTap: () => _confirmLogout(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const GoldDivider(),
              const SizedBox(height: 24),

              // Stats grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _StatCard(
                    value: '$totalViews',
                    label: 'VUES TOTAL',
                    color: AppColors.gold,
                    onTap: () => onTabSwitch?.call(1),
                  ),
                  _StatCard(
                    value: '$totalOrders',
                    label: 'COMMANDES',
                    color: AppColors.success,
                    onTap: () => onTabSwitch?.call(2),
                  ),
                  _StatCard(
                    value: '$surMesure',
                    label: 'SUR-MESURE',
                    color: AppColors.gold,
                    onTap: () => onTabSwitch?.call(3),
                  ),
                  _StatCard(
                    value: '$pending',
                    label: 'EN ATTENTE',
                    color: AppColors.info,
                    onTap: () => onTabSwitch?.call(2),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Recent activity
              const SectionLabel('Activité récente'),
              const SizedBox(height: 16),
              _ActivityItem(
                color: AppColors.success,
                title: 'Nouvelle commande',
                subtitle: 'Amina K. — Nuit Étoilée · il y a 2h',
                onTap: () => onTabSwitch?.call(2),
              ),
              _ActivityItem(
                color: AppColors.warning,
                title: 'Demande sur-mesure',
                subtitle: 'Chiara M. — Robe gala · il y a 5h',
                onTap: () => onTabSwitch?.call(3),
              ),
              _ActivityItem(
                color: AppColors.info,
                title: '42 vues · Lagon Bleu',
                subtitle: 'Pic de trafic · aujourd\'hui',
                onTap: () => onTabSwitch?.call(1),
              ),
              _ActivityItem(
                color: AppColors.error,
                title: 'Paiement M-Pesa confirmé',
                subtitle: 'Réf. VC-2025-0042 · hier',
                onTap: () => onTabSwitch?.call(2),
              ),
              const SizedBox(height: 32),

              // Top créations
              const SectionLabel('Top créations'),
              const SizedBox(height: 16),
              ...products.products
                  .toList()
                  .asMap()
                  .entries
                  .take(3)
                  .map((entry) => _TopCreationItem(
                        rank: entry.key + 1,
                        product: entry.value,
                        onTap: () => onTabSwitch?.call(1),
                      )),

              const SizedBox(height: 32),
              const SectionLabel('Paramètres contact'),
              const SizedBox(height: 16),
              const _WhatsAppSettingCard(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Déconnexion', style: TextStyle(color: AppColors.white)),
        content: const Text('Confirmer la déconnexion ?',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainClientScreen()),
                (_) => false,
              );
            },
            child: const Text('Déconnecter', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _AdminBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  const _AdminBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: color, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: onTap != null
                  ? color.withOpacity(0.3)
                  : AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value,
                style: TextStyle(
                    color: color, fontSize: 36, fontWeight: FontWeight.w700)),
            Row(
              children: [
                Expanded(
                  child: Text(label,
                      style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                          letterSpacing: 2)),
                ),
                if (onTap != null)
                  Icon(Icons.arrow_forward_ios,
                      size: 9, color: color.withOpacity(0.5)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ActivityItem({
    required this.color,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 10, height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.chevron_right,
                  color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}

class _TopCreationItem extends StatelessWidget {
  final int rank;
  final ProductModel product;
  final VoidCallback? onTap;

  const _TopCreationItem({
    required this.rank,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 48, height: 52,
                child: product.imageUrls.isNotEmpty
                    ? AppImage(
                        imageUrl: product.imageUrls.first,
                        fit: BoxFit.cover,
                        errorWidget: Container(
                          color: AppColors.card,
                          child: const Icon(Icons.checkroom,
                              color: AppColors.textMuted, size: 22),
                        ),
                      )
                    : Container(
                        color: AppColors.card,
                        child: const Icon(Icons.checkroom,
                            color: AppColors.textMuted, size: 22),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(
                          color: AppColors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('${product.viewCount} vues',
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.goldFaint,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gold.withOpacity(0.3)),
              ),
              child: Text('#$rank',
                  style: const TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w700,
                      fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

class _WhatsAppSettingCard extends StatefulWidget {
  const _WhatsAppSettingCard();
  @override
  State<_WhatsAppSettingCard> createState() => _WhatsAppSettingCardState();
}

class _WhatsAppSettingCardState extends State<_WhatsAppSettingCard> {
  bool _editing = false;
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chat_bubble,
                    color: Color(0xFF25D366), size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Numéro WhatsApp',
                        style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                    Text(settings.whatsappDisplay,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  _editing = !_editing;
                  if (_editing) _ctrl.text = settings.whatsappNumber;
                }),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _editing ? AppColors.goldFaint : AppColors.card,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: _editing
                            ? AppColors.gold
                            : AppColors.cardBorder),
                  ),
                  child: Text(
                    _editing ? 'Annuler' : 'Modifier',
                    style: TextStyle(
                        color: _editing
                            ? AppColors.gold
                            : AppColors.textSecondary,
                        fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          if (_editing) ...[
            const SizedBox(height: 14),
            TextFormField(
              controller: _ctrl,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: AppColors.white),
              decoration: const InputDecoration(
                hintText: '243XXXXXXXXX (sans + ni espaces)',
                prefixText: '+',
                prefixStyle: TextStyle(color: AppColors.gold),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  context.read<SettingsProvider>().setWhatsappNumber(_ctrl.text);
                  setState(() => _editing = false);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: AppColors.surface,
                    content: Text('Numéro WhatsApp mis à jour',
                        style: TextStyle(color: AppColors.white)),
                  ));
                },
                child: const Text('Enregistrer',
                    style: TextStyle(
                        color: AppColors.background,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            color: AppColors.gold, fontSize: 11, letterSpacing: 2.5));
  }
}
