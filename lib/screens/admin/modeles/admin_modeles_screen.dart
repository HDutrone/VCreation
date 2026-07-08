import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final List<XFile> _pickedImages = [];
  bool _picking = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_picking) return;
    setState(() => _picking = true);
    try {
      final picker = ImagePicker();
      final images = await picker.pickMultiImage(limit: 4);
      if (images.isNotEmpty) {
        setState(() {
          _pickedImages.addAll(images);
          if (_pickedImages.length > 4) {
            _pickedImages.removeRange(4, _pickedImages.length);
          }
        });
      }
    } finally {
      setState(() => _picking = false);
    }
  }

  void _removeImage(int index) {
    setState(() => _pickedImages.removeAt(index));
  }

  void _addModel() {
    if (_nameCtrl.text.trim().isEmpty) return;
    final imageUrls = _pickedImages.isNotEmpty
        ? _pickedImages.map((f) => f.path).toList()
        : <String>[];

    context.read<ProductsProvider>().addProduct(ProductModel(
      id: 'p${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      subtitle: _category.name,
      description: _descCtrl.text.trim(),
      category: _category,
      badge: _badge,
      imageUrls: imageUrls,
    ));
    _nameCtrl.clear();
    _descCtrl.clear();
    _pickedImages.clear();
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
                      child: Text(
                        _showAddForm ? '✕ Fermer' : '+ Ajouter',
                        style: const TextStyle(
                            color: AppColors.background,
                            fontWeight: FontWeight.w700,
                            fontSize: 13),
                      ),
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
                  decoration: const InputDecoration(hintText: 'Nom de la création'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descCtrl,
                  maxLines: 3,
                  style: const TextStyle(color: AppColors.white),
                  decoration: const InputDecoration(hintText: 'Description'),
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
                            case ProductCategory.robe: return 'Robe';
                            case ProductCategory.kaftan: return 'Kaftan';
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
                            case ProductBadge.nouveaute: return 'Nouveauté';
                          }
                        },
                        onChanged: (v) => setState(() => _badge = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Photo section
                const Text('PHOTOS',
                    style: TextStyle(
                        color: AppColors.gold, fontSize: 11, letterSpacing: 2.5)),
                const SizedBox(height: 10),

                // Picked images preview
                if (_pickedImages.isNotEmpty) ...[
                  SizedBox(
                    height: 90,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _pickedImages.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 80,
                              height: 90,
                              child: AppImage(
                                imageUrl: _pickedImages[i].path,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeImage(i),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close,
                                    size: 12, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                // Picker button
                if (_pickedImages.length < 4)
                  GestureDetector(
                    onTap: _picking ? null : _pickImages,
                    child: Container(
                      width: double.infinity,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.gold.withOpacity(0.5),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: _picking
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.gold, strokeWidth: 2))
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_photo_alternate_outlined,
                                    color: AppColors.gold, size: 28),
                                const SizedBox(height: 6),
                                Text(
                                  _pickedImages.isEmpty
                                      ? 'Ajouter 2–4 photos depuis la galerie'
                                      : 'Ajouter encore (${4 - _pickedImages.length} restant)',
                                  style: const TextStyle(
                                      color: AppColors.gold, fontSize: 12),
                                ),
                              ],
                            ),
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
                    color: product.isActive ? AppColors.goldFaint : AppColors.surface,
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
                        color: product.isActive ? AppColors.gold : AppColors.textMuted,
                        fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
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
                    product.isActive ? Icons.visibility : Icons.visibility_off_outlined,
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
          hint: Text(label, style: const TextStyle(color: AppColors.textMuted)),
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(itemLabel(i))))
              .toList(),
          onChanged: onChanged,
        ),
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
