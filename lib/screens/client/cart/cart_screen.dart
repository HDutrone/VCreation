import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../widgets/gold_button.dart';
import '../../../widgets/gold_divider.dart';
import '../../auth/login_screen.dart';
import 'payment_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text('Mon Panier',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 4),
              Text(
                '${cart.count} CRÉATION${cart.count != 1 ? 'S' : ''} SÉLECTIONNÉE${cart.count != 1 ? 'S' : ''}',
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 11, letterSpacing: 2),
              ),
              const SizedBox(height: 16),
              const GoldDivider(),
              const SizedBox(height: 16),

              if (cart.isEmpty) ...[
                Expanded(child: _EmptyCart()),
              ] else ...[
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) =>
                        _CartItemCard(item: cart.items[i]),
                  ),
                ),
                const SizedBox(height: 16),
                _PaymentMethods(),
                const SizedBox(height: 16),
                GoldButton(
                  label: 'Procéder au paiement',
                  onPressed: () {
                    if (!auth.isLoggedIn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()));
                      return;
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const PaymentScreen()));
                  },
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 80,
              height: 90,
              child: CachedNetworkImage(
                imageUrl: item.product.imageUrls.first,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.card),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.card,
                  child: const Icon(Icons.image_not_supported_outlined,
                      color: AppColors.textMuted, size: 28),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name,
                    style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.isSurMesure
                        ? AppColors.surface
                        : AppColors.goldFaint,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: item.isSurMesure
                            ? AppColors.cardBorder
                            : AppColors.gold.withOpacity(0.4)),
                  ),
                  child: Text(
                    item.typeLabel,
                    style: TextStyle(
                        color: item.isSurMesure
                            ? AppColors.textSecondary
                            : AppColors.gold,
                        fontSize: 11),
                  ),
                ),
                if (item.isSurMesure && item.consultationStatus != null) ...[
                  const SizedBox(height: 4),
                  Text(item.consultationStatus!,
                      style: const TextStyle(
                          color: AppColors.warning, fontSize: 12)),
                ],
                if (item.size != null) ...[
                  const SizedBox(height: 4),
                  Text('Taille : ${item.size}',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ],
            ),
          ),
          // Right side
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => cart.removeItem(item.id),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.card,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close,
                      size: 14, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 24),
              Text('Qté : ${item.quantity}',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentMethods extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('MODES DE PAIEMENT ACCEPTÉS',
              style: TextStyle(
                  color: AppColors.textMuted, fontSize: 10, letterSpacing: 2)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: const [
              _PayBadge(icon: Icons.credit_card, label: 'Carte Bancaire',
                  color: AppColors.gold),
              _PayBadge(icon: Icons.phone_android, label: 'M-Pesa',
                  color: AppColors.textSecondary),
              _PayBadge(icon: Icons.circle, label: 'Orange Money',
                  color: Colors.orange),
              _PayBadge(icon: Icons.bar_chart, label: 'Africell Money',
                  color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
}

class _PayBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _PayBadge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shopping_bag_outlined,
              size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          const Text('Votre panier est vide',
              style: TextStyle(color: AppColors.white, fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Explorez nos collections et ajoutez vos créations préférées.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}
