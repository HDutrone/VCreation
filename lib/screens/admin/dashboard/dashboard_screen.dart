import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/product_model.dart';
import '../../../providers/orders_provider.dart';
import '../../../providers/products_provider.dart';
import '../../../widgets/gold_divider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>();
    final products = context.watch<ProductsProvider>();

    final totalViews = products.products.fold<int>(0, (s, p) => s + p.viewCount);
    final totalOrders = orders.orders.length;
    final surMesure = orders.customRequests.length;
    final pending = orders.newOrders.length + orders.customRequests
        .where((r) => r.status.name == 'nouvelle').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text('BIENVENUE',
                  style: TextStyle(
                      color: AppColors.textMuted, fontSize: 11, letterSpacing: 3)),
              const SizedBox(height: 4),
              Text('Tableau de bord',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 34)),
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
                  _StatCard(value: '$totalViews', label: 'VUES TOTAL',
                      color: AppColors.gold),
                  _StatCard(value: '$totalOrders', label: 'COMMANDES',
                      color: AppColors.success),
                  _StatCard(value: '$surMesure', label: 'SUR-MESURE',
                      color: AppColors.gold),
                  _StatCard(value: '$pending', label: 'EN ATTENTE',
                      color: AppColors.info),
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
              ),
              _ActivityItem(
                color: AppColors.warning,
                title: 'Demande sur-mesure',
                subtitle: 'Chiara M. — Robe gala · il y a 5h',
              ),
              _ActivityItem(
                color: AppColors.info,
                title: '42 vues · Lagon Bleu',
                subtitle: 'Pic de trafic · aujourd\'hui',
              ),
              _ActivityItem(
                color: AppColors.error,
                title: 'Paiement M-Pesa confirmé',
                subtitle: 'Réf. VC-2025-0042 · hier',
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
                      )),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCard({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 36, fontWeight: FontWeight.w700)),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 10, letterSpacing: 2)),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;

  const _ActivityItem({required this.color, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopCreationItem extends StatelessWidget {
  final int rank;
  final ProductModel product;

  const _TopCreationItem({required this.rank, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Container(
              width: 48,
              height: 52,
              color: AppColors.card,
              child: const Icon(Icons.checkroom, color: AppColors.textMuted, size: 22),
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
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
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
                    color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
