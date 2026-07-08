import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/product_model.dart';
import '../../../providers/products_provider.dart';
import '../../../widgets/app_image.dart';
import '../../../widgets/gold_button.dart';
import '../../../widgets/gold_divider.dart';

class AdminModelesScreen extends StatefulWidget {
  const AdminModelesScreen({super.key});

  @override
  State<AdminModelesScreen> createState() => _AdminModelesScreenState();
}

class _AdminModelesScreenState extends State<AdminModelesScreen> {
  bool _showAddForm = false;
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  ProductCategory _category = ProductCategory.robe;
  ProductBadge _badge = ProductBadge.pieceSignature;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _addModel() {
    if (_nameCtrl.text.trim().isEmpty) return;
    context.read<ProductsProvider>().addProduct(ProductModel(
      id: 'p${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      subtitle: _category.name,
      description: _descCtrl.text.trim(),
      category: _category,
      badge: _badge,
      imageUrls: ['https://picsum.photos/seed/${_nameCtrl.text}/800/1000'],
    ));
    _nameCtrl.clear();
    _descCtrl.clear();
    setState(() => _showAddForm = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.surface,
        content: Text('Modèle enregistré', style: TextStyle(color: AppColors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductsProvider>().products;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Modèles',
                          style: Theme.of(context).textTheme.headlineLarge),
                      Text('${products.length} CRÉATIONS',
                          style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                              letterSpacing: 2)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _showAddForm = !_showAddForm),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('+ Ajouter',
                          style: TextStyle(
                              color: AppColors.background,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const GoldDivider(),
              const SizedBox(height: 20),

              // Product list
              ...products.map((p) => _ModelRow(product: p)),

              const SizedBox(height: 24),

              // Add form
              if (_showAddForm) ...[
                const SectionLabel('Ajouter un modèle'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameCtrl,
                  style: const TextStyle(color: AppColors.white),
                  decoration:
                      const InputDecoration(hintText: 'Nom de la création'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descCtrl,
                  maxLines: 3,
                  style: const TextStyle(color: AppColors.white),
                  decoration:
                      const InputDecoration(hintText: 'Description'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _DropdownField<ProductCategory>(
                        label: 'Catégorie',
                        value: _category,
                        items: ProductCategory.values,
                        itemLabel: (c) {
                          switch (c) {
                            case ProductCategory.robe:    return 'Robe';
                            case ProductCategory.kaftan:  return 'Kaftan';
                            case ProductCategory.tailleur: return 'Tailleur';
                            case ProductCategory.ensemble: return 'Ensemble';
                          }
                        },
                        onChanged: (v) => setState(() => _category = v!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DropdownField<ProductBadge>(
                        label: 'Badge',
                        value: _badge,
                        items: ProductBadge.values,
                        itemLabel: (b) {
                          switch (b) {
                            case ProductBadge.pieceSignature: return 'Signature';
                            case ProductBadge.surMesureDispo: return 'Sur-mesure';
                            case ProductBadge.nouveaute:      return 'Nouveauté';
                          }
                        },
                        onChanged: (v) => setState(() => _badge = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Photo add placeholder
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.cardBorder,
                        style: BorderStyle.solid),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined,
                          color: AppColors.textMuted, size: 28),
                      SizedBox(height: 8),
                      Text('Ajouter 2–4 photos',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GoldButton(label: 'Enregistrer le modèle', onPressed: _addModel),
                const SizedBox(height: 40),
              ] else ...[
                const SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ModelRow extends StatelessWidget {
  final ProductModel product;
  const _ModelRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductsProvider>();
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 60,
              height: 68,
              child: product.imageUrls.isNotEmpty
                  ? AppImage(
                      imageUrl: product.imageUrls.first,
                      fit: BoxFit.cover,
                      errorWidget: Container(
                        color: AppColors.card,
                        child: const Icon(Icons.checkroom,
                            color: AppColors.textMuted, size: 24),
                      ),
                    )
                  : Container(
                      color: AppColors.card,
                      child: const Icon(Icons.checkroom,
                          color: AppColors.textMuted, size: 24),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                const SizedBox(height: 3),
                Text('${product.categoryShort} · ${product.photoCount}',
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: product.isActive
                        ? AppColors.goldFaint
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: product.isActive
                          ? AppColors.gold.withOpacity(0.4)
                          : AppColors.cardBorder,
                    ),
                  ),
                  child: Text(
                    product.isActive ? 'Publié' : 'Désactivé',
                    style: TextStyle(
                        color: product.isActive
                            ? AppColors.gold
                            : AppColors.textMuted,
                        fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          // Actions
          Row(
            children: [
              GestureDetector(
                onTap: () => provider.toggleActive(product.id),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Icon(
                    product.isActive
                        ? Icons.visibility
                        : Icons.visibility_off_outlined,
                    size: 18,
                    color: product.isActive ? AppColors.gold : AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _confirmDelete(context, product, provider),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Icon(Icons.close, size: 18, color: AppColors.error),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, ProductModel p, ProductsProvider provider) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Supprimer', style: TextStyle(color: AppColors.white)),
        content: Text('Supprimer "${p.name}" définitivement ?',
            style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler', style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              provider.removeProduct(p.id);
              Navigator.pop(ctx);
            },
            child: const Text('Supprimer', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          dropdownColor: AppColors.surface,
          style: const TextStyle(color: AppColors.white, fontSize: 13),
          isExpanded: true,
          hint: Text(label,
              style: const TextStyle(color: AppColors.textMuted)),
          items: items
              .map((i) => DropdownMenuItem(
                    value: i,
                    child: Text(itemLabel(i)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
