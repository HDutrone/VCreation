import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/product_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/products_provider.dart';
import '../../../widgets/app_image.dart';
import '../sur_mesure/sur_mesure_screen.dart';

class CollectionDetailScreen extends StatefulWidget {
  final ProductModel product;
  const CollectionDetailScreen({super.key, required this.product});

  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  int _selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cart = context.read<CartProvider>();
    final products = context.read<ProductsProvider>();
    final inCart = context.watch<CartProvider>().isInCart(product.id);
    final isFav = context.watch<ProductsProvider>().findById(product.id)?.isFavorite ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chevron_left, color: AppColors.white),
          ),
        ),
        title: const Text('COLLECTIONS', style: TextStyle(letterSpacing: 4, fontSize: 12)),
        actions: [
          GestureDetector(
            onTap: () => products.toggleFavorite(product.id),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? AppColors.error : AppColors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main image
            Container(
              height: 380,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(
                    imageUrl: product.imageUrls[_selectedImage],
                    fit: BoxFit.cover,
                    errorWidget: Container(
                      color: AppColors.card,
                      child: Center(
                        child: Text(product.name,
                            style: const TextStyle(
                                color: AppColors.textMuted, fontSize: 16)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => _openFullScreen(context, product),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.fullscreen, size: 14, color: AppColors.white),
                            SizedBox(width: 4),
                            Text('Plein écran',
                                style: TextStyle(
                                    color: AppColors.white, fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Thumbnail strip
            if (product.imageUrls.length > 1)
              SizedBox(
                height: 72,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemCount: product.imageUrls.length,
                  itemBuilder: (_, i) => GestureDetector(
                    onTap: () => setState(() => _selectedImage = i),
                    child: Container(
                      width: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedImage == i
                              ? AppColors.gold
                              : AppColors.cardBorder,
                          width: _selectedImage == i ? 2 : 1,
                        ),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: AppImage(
                        imageUrl: product.imageUrls[i],
                        fit: BoxFit.cover,
                        placeholder: Container(color: AppColors.card),
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Title block
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name,
                            style: Theme.of(context).textTheme.headlineLarge),
                        const SizedBox(height: 4),
                        Text(product.categoryLabel,
                            style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                                letterSpacing: 2)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.cardBorder),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(product.badgeLabel,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            // Gold dot divider
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _GoldDotLine(),
            ),
            const SizedBox(height: 16),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                product.description,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ),

            const SizedBox(height: 32),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SurMesureScreen()),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28)),
                        ),
                        child: const Text(
                          'DEMANDER SUR-MESURE',
                          style: TextStyle(
                              color: AppColors.background,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      if (!inCart) {
                        cart.addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.surface,
                            content: Text(
                              '${product.name} ajouté au panier',
                              style: const TextStyle(color: AppColors.white),
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: inCart ? AppColors.gold : AppColors.cardBorder,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        color: inCart ? AppColors.goldFaint : Colors.transparent,
                      ),
                      child: Icon(
                        inCart ? Icons.check : Icons.add,
                        color: inCart ? AppColors.gold : AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _openFullScreen(BuildContext ctx, ProductModel product) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _FullScreenGallery(product: product),
      ),
    );
  }
}

class _GoldDotLine extends StatelessWidget {
  const _GoldDotLine();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 60, height: 0.5, color: AppColors.divider),
        Container(
          width: 6, height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(
              color: AppColors.gold, shape: BoxShape.circle),
        ),
        Container(width: 60, height: 0.5, color: AppColors.divider),
      ],
    );
  }
}

class _FullScreenGallery extends StatefulWidget {
  final ProductModel product;
  const _FullScreenGallery({required this.product});

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late PageController _pageCtrl;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.product.imageUrls;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${_page + 1} / ${images.length}',
            style: const TextStyle(color: AppColors.white, fontSize: 14)),
      ),
      body: PageView.builder(
        controller: _pageCtrl,
        onPageChanged: (i) => setState(() => _page = i),
        itemCount: images.length,
        itemBuilder: (_, i) => InteractiveViewer(
          child: AppImage(
            imageUrl: images[i],
            fit: BoxFit.contain,
            placeholder: const Center(
                child: CircularProgressIndicator(color: AppColors.gold)),
            errorWidget: Container(color: Colors.black12),
          ),
        ),
      ),
    );
  }
}
