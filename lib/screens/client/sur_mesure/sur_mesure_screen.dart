import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/custom_request_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/orders_provider.dart';
import '../../../widgets/gold_button.dart';
import '../../../widgets/gold_divider.dart';

class SurMesureScreen extends StatefulWidget {
  const SurMesureScreen({super.key});

  @override
  State<SurMesureScreen> createState() => _SurMesureScreenState();
}

class _SurMesureScreenState extends State<SurMesureScreen> {
  String? _garmentType;
  String? _occasion;
  String? _delai;
  final _messageCtrl = TextEditingController();
  bool _loading = false;

  static const _garments = ['Robe de soirée', 'Kaftan', 'Tailleur', 'Ensemble'];
  static const _occasions = ['Mariage', 'Gala', 'Corporate', 'Cérémonie', 'Autre'];
  static const _delais = ['1 mois', '2 mois', '3 mois', '6 mois', 'Flexible'];

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_garmentType == null || _occasion == null || _delai == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.surface,
          content: Text('Veuillez compléter toutes les options.',
              style: TextStyle(color: AppColors.white)),
        ),
      );
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));

    final auth = context.read<AuthProvider>();
    final name = auth.user?.displayName ?? 'Client';

    context.read<OrdersProvider>().addCustomRequest(CustomRequestModel(
      id: 'cr${DateTime.now().millisecondsSinceEpoch}',
      clientName: name,
      garmentType: _garmentType!,
      occasion: _occasion!,
      delai: _delai!,
      message: _messageCtrl.text.trim().isEmpty
          ? 'Pas de message supplémentaire.'
          : _messageCtrl.text.trim(),
      receivedAt: 'à l\'instant',
      status: CustomRequestStatus.nouvelle,
    ));

    if (!mounted) return;
    setState(() => _loading = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold, width: 1.5),
              ),
              child: const Icon(Icons.check, color: AppColors.gold, size: 28),
            ),
            const SizedBox(height: 16),
            const Text('Demande envoyée',
                style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18)),
            const SizedBox(height: 10),
            const Text(
              'Notre atelier vous contactera dans les 24h pour affiner votre demande.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _garmentType = null;
                _occasion = null;
                _delai = null;
                _messageCtrl.clear();
              });
            },
            child: const Text('Fermer', style: TextStyle(color: AppColors.gold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text('L\'ART DU',
                  style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      letterSpacing: 3)),
              const SizedBox(height: 4),
              Text('Sur-Mesure',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.white,
                        fontSize: 40,
                      )),
              const SizedBox(height: 16),
              const GoldDivider(),
              const SizedBox(height: 20),
              const Text(
                'Chaque création naît d\'un dialogue entre vous et notre atelier. '
                'Partagez votre vision, nous la sublimerons.',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 14, height: 1.7),
              ),
              const SizedBox(height: 32),

              // TYPE DE TENUE
              const SectionLabel('Type de tenue'),
              const SizedBox(height: 12),
              _ChipGroup(
                options: _garments,
                selected: _garmentType,
                onSelect: (v) => setState(() => _garmentType = v),
              ),
              const SizedBox(height: 24),

              // OCCASION
              const SectionLabel('Occasion'),
              const SizedBox(height: 12),
              _ChipGroup(
                options: _occasions,
                selected: _occasion,
                onSelect: (v) => setState(() => _occasion = v),
              ),
              const SizedBox(height: 24),

              // DÉLAI SOUHAITÉ
              const SectionLabel('Délai souhaité'),
              const SizedBox(height: 12),
              _ChipGroup(
                options: _delais,
                selected: _delai,
                onSelect: (v) => setState(() => _delai = v),
              ),
              const SizedBox(height: 24),

              // MESSAGE
              const SectionLabel('Message personnalisé'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _messageCtrl,
                maxLines: 5,
                style: const TextStyle(color: AppColors.white),
                decoration: const InputDecoration(
                  hintText: 'Décrivez votre vision, vos inspirations...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 32),

              GoldButton(
                label: 'Demander une consultation',
                isLoading: _loading,
                onPressed: _submit,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipGroup extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;

  const _ChipGroup({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options
          .map((o) => GestureDetector(
                onTap: () => onSelect(o),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selected == o ? AppColors.gold : AppColors.cardBorder,
                      width: selected == o ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: selected == o ? AppColors.goldFaint : Colors.transparent,
                  ),
                  child: Text(
                    o,
                    style: TextStyle(
                      color: selected == o ? AppColors.gold : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: selected == o ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
