import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/product_model.dart';
import '../../../providers/products_provider.dart';
import '../../../widgets/app_image.dart';
import 'collection_detail_screen.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  // null = toutes, 0-3 = ProductCategory.values index
  int? _filterIndex;

  ProductCategory? get _filter =>
      _filterIndex == null ? null : ProductCategory.values[_filterIndex!];

  @override
  Widget build(BuildContext context) {
    final all = context.watch<ProductsProvider>().activeProducts;
    final filtered =
        _filter == null ? all : all.where((p) => p.category == _filter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Collections',
                    style: Theme.of(context).textTheme.headlineLarge),
                Text(
                  '${all.length} CRÉATIONS',
                  style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      letterSpacing: 2),
                ),
              ],
            ),
            titleSpacing: 20,
            toolbarHeight: 72,
            actions: [
              PopupMenuButton<int>(
                color: AppColors.surface,
                // Use int index to avoid null-selection issue with nullable type
                onSelected: (v) =>
                    setState(() => _filterIndex = v == -1 ? null : v),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                      value: -1,
                      child: Text('Toutes',
                          style: TextStyle(color: AppColors.white))),
                  const PopupMenuItem(
                      value: 0,
                      child: Text('Robes',
                          style: TextStyle(color: AppColors.white))),
                  const PopupMenuItem(
                      value: 1,
                      child: Text('Kaftans',
                          style: TextStyle(color: AppColors.white))),
                  const PopupMenuItem(
                      value: 2,
                      child: Text('Tailleurs',
                          style: TextStyle(color: AppColors.white))),
                  const PopupMenuItem(
                      value: 3,
                      child: Text('Ensembles',
                          style: TextStyle(color: AppColors.white))),
                ],
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: _filterIndex != null
                            ? AppColors.gold
                            : AppColors.cardBorder),
                    borderRadius: BorderRadius.circular(20),
                    color: _filterIndex != null
                        ? AppColors.goldFaint
                        : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Text(
                        _filterIndex == null
                            ? 'Filtrer'
                            : _filterLabel(_filterIndex!),
                        style: TextStyle(
                            color: _filterIndex != null
                                ? AppColors.gold
                                : AppColors.textSecondary,
                            fontSize: 13),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: _filterIndex != null
                            ? AppColors.gold
                            : AppColors.textMuted,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 80, height: 0.5, color: AppColors.divider),
                    Container(
                      width: 6, height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: const BoxDecoration(
                          color: AppColors.gold, shape: BoxShape.circle),
                    ),
                    Container(width: 80, height: 0.5, color: AppColors.divider),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          if (filtered.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Center(
                  child: Text(
                    'Aucune création dans cette catégorie.',
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.70,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _CollectionCard(product: filtered[i]),
                  childCount: filtered.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  String _filterLabel(int idx) {
    switch (ProductCategory.values[idx]) {
      case ProductCategory.robe:     return 'Robes';
      case ProductCategory.kaftan:   return 'Kaftans';
      case ProductCategory.tailleur: return 'Tailleurs';
      case ProductCategory.ensemble: return 'Ensembles';
    }
  }
}

class _CollectionCard extends StatelessWidget {
  final ProductModel product;
  const _CollectionCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CollectionDetailScreen(product: product)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  product.imageUrls.isNotEmpty
                      ? AppImage(
                          imageUrl: product.imageUrls.first,
                          fit: BoxFit.cover,
                          errorWidget: _colorBlock(product),
                        )
                      : _colorBlock(product),
                  Positioned(
                    top: 10, right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.grid_view,
                              size: 10, color: AppColors.white),
                          SizedBox(width: 4),
                          Text('Galerie',
                              style: TextStyle(
                                  color: AppColors.white, fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10, bottom: 10,
                    child: Text('${product.viewCount} vues',
                        style: const TextStyle(
                            color: AppColors.white, fontSize: 10)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(product.name,
              style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: product.badge == ProductBadge.pieceSignature
                  ? AppColors.goldFaint
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: product.badge == ProductBadge.pieceSignature
                    ? AppColors.gold.withOpacity(0.4)
                    : AppColors.cardBorder,
              ),
            ),
            child: Text(
              product.badgeLabel,
              style: TextStyle(
                color: product.badge == ProductBadge.pieceSignature
                    ? AppColors.gold
                    : AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorBlock(ProductModel p) {
    final colors = [
      AppColors.card,
      const Color(0xFF1C2233),
      const Color(0xFF1A1A2E),
      const Color(0xFF2A1A1A),
    ];
    final idx = p.id.hashCode % colors.length;
    return Container(
      color: colors[idx.abs()],
      child: Center(
        child: Text(p.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppColors.textMuted, fontSize: 12)),
      ),
    );
  }
}
