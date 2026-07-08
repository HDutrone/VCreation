import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/order_model.dart';
import '../../../providers/orders_provider.dart';
import '../../../widgets/gold_divider.dart';

class AdminCommandesScreen extends StatefulWidget {
  const AdminCommandesScreen({super.key});

  @override
  State<AdminCommandesScreen> createState() => _AdminCommandesScreenState();
}

class _AdminCommandesScreenState extends State<AdminCommandesScreen> {
  int _tab = 0; // 0=Toutes, 1=En cours, 2=Livrées

  @override
  Widget build(BuildContext context) {
    final ordersProvider = context.watch<OrdersProvider>();
    final List<OrderModel> displayed = switch (_tab) {
      1 => [...ordersProvider.newOrders, ...ordersProvider.inProgressOrders],
      2 => ordersProvider.deliveredOrders,
      _ => ordersProvider.orders,
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text('Commandes',
                  style: Theme.of(context).textTheme.headlineLarge),
              Text('${ordersProvider.orders.length} COMMANDES',
                  style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      letterSpacing: 2)),
              const SizedBox(height: 16),
              const GoldDivider(),
              const SizedBox(height: 16),

              // Tab bar
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    _Tab(label: 'Toutes', active: _tab == 0,
                        onTap: () => setState(() => _tab = 0)),
                    _Tab(label: 'En cours', active: _tab == 1,
                        onTap: () => setState(() => _tab = 1)),
                    _Tab(label: 'Livrées', active: _tab == 2,
                        onTap: () => setState(() => _tab = 2)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: displayed.isEmpty
                    ? const Center(
                        child: Text('Aucune commande',
                            style: TextStyle(color: AppColors.textSecondary)))
                    : ListView.separated(
                        itemCount: displayed.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) =>
                            _AdminOrderCard(order: displayed[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: active ? AppColors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: active ? AppColors.background : AppColors.textSecondary,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminOrderCard extends StatelessWidget {
  final OrderModel order;
  const _AdminOrderCard({required this.order});

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.nouveau:   return AppColors.info;
      case OrderStatus.enCours:   return AppColors.warning;
      case OrderStatus.livre:     return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.checkroom, color: AppColors.textMuted, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.clientName,
                    style: const TextStyle(
                        color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 3),
                Text('${order.productName} · ${order.reference}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 2),
                Text('${order.paymentLabel} · ${order.createdAt}',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
          _StatusBadge(label: order.statusLabel, color: _statusColor),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
