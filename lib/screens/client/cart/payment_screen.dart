import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/order_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/orders_provider.dart';
import '../../../widgets/gold_button.dart';
import '../../../widgets/gold_divider.dart';
import 'payment_confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _method = PaymentMethod.carteBancaire;
  final _holderCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  bool _loading = false;

  static const _methods = [
    (PaymentMethod.carteBancaire, Icons.credit_card, 'Carte Bancaire', AppColors.gold),
    (PaymentMethod.mPesa, Icons.phone_android, 'M-Pesa', Color(0xFF4CAF50)),
    (PaymentMethod.orangeMoney, Icons.circle, 'Orange Money', Colors.orange),
    (PaymentMethod.africellMoney, Icons.bar_chart, 'Africell Money', Colors.orange),
  ];

  bool get _isMobileMoney => _method != PaymentMethod.carteBancaire;

  @override
  void dispose() {
    _holderCtrl.dispose();
    _numberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));

    final auth = context.read<AuthProvider>();
    final cart = context.read<CartProvider>();
    final orders = context.read<OrdersProvider>();

    // Build order reference
    final productName = cart.items.isNotEmpty
        ? cart.items.map((i) => i.product.name).join(', ')
        : 'Création V';
    final ref = orders.addOrder(
      clientName: auth.user?.name ?? 'Client',
      productName: productName,
      paymentMethod: _method,
    );

    // Redirect to FlexPay gateway for mobile money
    if (_isMobileMoney) {
      final flexpayUrl = Uri.parse(
        'https://dashboard.flexpay.cd/gateway?merchant=vcreations&ref=$ref'
        '&amount=0&currency=USD&description=${Uri.encodeComponent(productName)}',
      );
      if (await canLaunchUrl(flexpayUrl)) {
        await launchUrl(flexpayUrl, mode: LaunchMode.externalApplication);
      }
    }

    cart.clear();

    if (!mounted) return;
    setState(() => _loading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentConfirmationScreen(reference: ref),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Paiement', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 4),
            const Text('Sélectionnez votre mode de paiement',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 16),
            const GoldDivider(),
            const SizedBox(height: 24),

            const Text('MODE DE PAIEMENT',
                style: TextStyle(
                    color: AppColors.gold, fontSize: 11, letterSpacing: 2.5)),
            const SizedBox(height: 12),

            // Payment method selection
            ..._methods.map((m) {
              final (method, icon, label, color) = m;
              final selected = _method == method;
              return GestureDetector(
                onTap: () => setState(() => _method = method),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.goldFaint : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? AppColors.gold : AppColors.cardBorder,
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected ? AppColors.gold : AppColors.textMuted,
                            width: 1.5,
                          ),
                        ),
                        child: selected
                            ? Center(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: AppColors.gold,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Icon(icon, size: 20, color: color),
                      const SizedBox(width: 12),
                      Text(label,
                          style: TextStyle(
                              color: selected ? AppColors.white : AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400)),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),
            const Text('INFORMATIONS',
                style: TextStyle(
                    color: AppColors.gold, fontSize: 11, letterSpacing: 2.5)),
            const SizedBox(height: 12),

            TextFormField(
              controller: _holderCtrl,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                hintText: _isMobileMoney
                    ? 'Nom de l\'abonné'
                    : 'Nom du titulaire / Abonné',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _numberCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                hintText: _isMobileMoney
                    ? 'Numéro de téléphone'
                    : 'Numéro de carte / téléphone',
              ),
            ),
            if (!_isMobileMoney) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.white),
                      decoration: const InputDecoration(hintText: 'MM/AA'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvCtrl,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      style: const TextStyle(color: AppColors.white),
                      decoration: const InputDecoration(hintText: 'CVV'),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // Order summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('RÉCAPITULATIF',
                      style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                          letterSpacing: 2)),
                  const SizedBox(height: 12),
                  ...cart.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.product.name,
                                style: const TextStyle(color: AppColors.white)),
                            Text(item.priceLabel,
                                style: const TextStyle(
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      )),
                  const Divider(color: AppColors.cardBorder),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style: TextStyle(
                              color: AppColors.white, fontWeight: FontWeight.w700)),
                      const Text('Sur devis',
                          style: TextStyle(
                              color: AppColors.gold, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            GoldButton(
              label: _isMobileMoney
                  ? 'Procéder au paiement FlexPay'
                  : 'Confirmer le paiement',
              isLoading: _loading,
              onPressed: _confirm,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
