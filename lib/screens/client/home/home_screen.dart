import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/product_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/products_provider.dart';
import '../../../widgets/vcreations_logo.dart';
import '../../../widgets/whatsapp_fab.dart';
import '../collections/collection_detail_screen.dart';
import '../../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductCategory? _filter; // null = tous

  static const _categories = [
    (null, 'Tous'),
    (ProductCategory.robe, 'Soirée'),
    (ProductCategory.kaftan, 'Kaftan'),
    (ProductCategory.ensemble, 'Sur-mesure'),
  ];

  List<ProductModel> _filtered(List<ProductModel> products) {
    if (_filter == null) return products;
    return products.where((p) => p.category == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductsProvider>().activeProducts;
    final auth = context.watch<AuthProvider>();
    final featured = _filtered(products);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            expandedHeight: 0,
            title: const VCreationsLogoSmall(height: 34),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.white),
                onPressed: () {},
              ),
              GestureDetector(
                onTap: () {
                  if (!auth.isLoggedIn) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  }
                },
                child: Container(
                  width: 34,
                  height: 34,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 1.5),
                    color: auth.isLoggedIn
                        ? AppColors.goldFaint
                        : AppColors.surface,
                  ),
                  child: Center(
                    child: Text(
                      auth.isLoggedIn
                          ? auth.user!.initials
                          : '?',
                      style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero banner
                _HeroBanner(product: products.isNotEmpty ? products.first : null),
                const SizedBox(height: 20),

                // Category filter
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemCount: _categories.length,
                    itemBuilder: (_, i) {
                      final (cat, label) = _categories[i];
                      final selected = _filter == cat;
                      return GestureDetector(
                        onTap: () => setState(() => _filter = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  selected ? AppColors.gold : AppColors.cardBorder,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: selected
                                ? AppColors.goldFaint
                                : Colors.transparent,
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              color: selected
                                  ? AppColors.gold
                                  : AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Gold dot separator
                const Center(
                  child: _GoldDot(),
                ),
                const SizedBox(height: 24),

                // Créations vedettes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Créations vedettes',
                          style: Theme.of(context).textTheme.titleLarge),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Voir tout ›',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: featured.take(4).length,
                    itemBuilder: (_, i) =>
                        _ProductCard(product: featured[i]),
                  ),
                ),
                const SizedBox(height: 32),

                // WhatsApp banner
                const WhatsAppBanner(),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final ProductModel? product;
  const _HeroBanner({this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (product != null)
            CachedNetworkImage(
              imageUrl: product!.imageUrls.first,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: AppColors.card),
              errorWidget: (_, __, ___) => _PlaceholderImage(label: product!.name),
            )
          else
            const _PlaceholderImage(label: 'NOUVELLE COLLECTION'),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),
          // Top right badge
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Nouveauté',
                  style: TextStyle(color: AppColors.white, fontSize: 11)),
            ),
          ),
          // Bottom text
          Positioned(
            left: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('NOUVELLE COLLECTION',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        letterSpacing: 2)),
                const SizedBox(height: 4),
                Text(
                  product?.name ?? 'Collection 2025',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

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
                    placeholder: (_, __) =>
                        Container(color: AppColors.card),
                    errorWidget: (_, __, ___) =>
                        _PlaceholderImage(label: product.name),
                  ),
                  // Galerie badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.grid_view,
                              size: 10, color: AppColors.white),
                          const SizedBox(width: 4),
                          const Text('Galerie',
                              style: TextStyle(
                                  color: AppColors.white, fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                  // View count
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Text(
                      '${product.viewCount} vues',
                      style: const TextStyle(
                          color: AppColors.white, fontSize: 10),
                    ),
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
}

class _PlaceholderImage extends StatelessWidget {
  final String label;
  const _PlaceholderImage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.card,
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _GoldDot extends StatelessWidget {
  const _GoldDot();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 60, height: 0.5, color: AppColors.divider),
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(
            color: AppColors.gold,
            shape: BoxShape.circle,
          ),
        ),
        Container(width: 60, height: 0.5, color: AppColors.divider),
      ],
    );
  }
}
