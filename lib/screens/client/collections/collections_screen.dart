import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/product_model.dart';
import '../../../providers/products_provider.dart';
import 'collection_detail_screen.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  ProductCategory? _filter;

  @override
  Widget build(BuildContext context) {
    final all = context.watch<ProductsProvider>().activeProducts;
    final filtered = _filter == null
        ? all
        : all.where((p) => p.category == _filter).toList();

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
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            titleSpacing: 20,
            toolbarHeight: 72,
            actions: [
              PopupMenuButton<ProductCategory?>(
                color: AppColors.surface,
                onSelected: (v) => setState(() => _filter = v),
                itemBuilder: (_) => [
                  const PopupMenuItem(value: null, child: Text('Toutes', style: TextStyle(color: AppColors.white))),
                  const PopupMenuItem(value: ProductCategory.robe, child: Text('Robes', style: TextStyle(color: AppColors.white))),
                  const PopupMenuItem(value: ProductCategory.kaftan, child: Text('Kaftans', style: TextStyle(color: AppColors.white))),
                  const PopupMenuItem(value: ProductCategory.tailleur, child: Text('Tailleurs', style: TextStyle(color: AppColors.white))),
                  const PopupMenuItem(value: ProductCategory.ensemble, child: Text('Ensembles', style: TextStyle(color: AppColors.white))),
                ],
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.cardBorder),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Text('Filtrer', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: AppColors.textMuted, size: 16),
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
                // Gold dot separator
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

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  CachedNetworkImage(
                    imageUrl: product.imageUrls.first,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.card),
                    errorWidget: (_, __, ___) => _colorBlock(product),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.grid_view, size: 10, color: AppColors.white),
                          SizedBox(width: 4),
                          Text('Galerie',
                              style: TextStyle(color: AppColors.white, fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Text('${product.viewCount} vues',
                        style: const TextStyle(color: AppColors.white, fontSize: 10)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(product.name,
              style: const TextStyle(
                  color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 14)),
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
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
      ),
    );
  }
}
