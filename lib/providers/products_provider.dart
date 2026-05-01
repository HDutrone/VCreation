import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class ProductsProvider extends ChangeNotifier {
  final List<ProductModel> _products = [
    const ProductModel(
      id: 'p1',
      name: 'Nuit Étoilée',
      subtitle: 'Robe Haute Couture',
      description:
          'Création en franges noires superposées, travail artisanal minutieux '
          'réalisé entièrement à la main. Inspirée du jazz de l\'ère Art Déco, '
          'cette pièce unique allie élégance structurée et mouvement perpétuel.',
      category: ProductCategory.robe,
      badge: ProductBadge.pieceSignature,
      imageUrls: [
        'https://picsum.photos/seed/nuit1/800/1000',
        'https://picsum.photos/seed/nuit2/800/1000',
      ],
      viewCount: 86,
    ),
    const ProductModel(
      id: 'p2',
      name: 'Lagon Bleu',
      subtitle: 'Kaftan Haute Couture',
      description:
          'Kaftan fluide à imprimé aquarelle, façonné dans un satin de soie '
          'premium. Trois vues pour révéler son amplitude en mouvement.',
      category: ProductCategory.kaftan,
      badge: ProductBadge.surMesureDispo,
      imageUrls: [
        'https://picsum.photos/seed/lagon1/800/1000',
        'https://picsum.photos/seed/lagon2/800/1000',
        'https://picsum.photos/seed/lagon3/800/1000',
      ],
      viewCount: 98,
    ),
    const ProductModel(
      id: 'p3',
      name: 'Soleil Rouge',
      subtitle: 'Robe Haute Couture',
      description:
          'Robe soleil aux teintes enflammées, taillée dans une mousseline '
          'légère aux reflets iridescents. Une silhouette libre qui célèbre '
          'la femme dans toute sa splendeur.',
      category: ProductCategory.robe,
      badge: ProductBadge.pieceSignature,
      imageUrls: [
        'https://picsum.photos/seed/soleil1/800/1000',
      ],
      viewCount: 64,
    ),
    const ProductModel(
      id: 'p4',
      name: 'Harmonie',
      subtitle: 'Kaftan Haute Couture',
      description:
          'Collection trio de kaftans en soieries imprimées. Trois silhouettes, '
          'trois récits, une harmonie parfaite. Disponible en ensemble ou en '
          'pièce individuelle.',
      category: ProductCategory.kaftan,
      badge: ProductBadge.surMesureDispo,
      imageUrls: [
        'https://picsum.photos/seed/harmonie1/800/1000',
      ],
      viewCount: 42,
    ),
    const ProductModel(
      id: 'p5',
      name: 'Aube Dorée',
      subtitle: 'Tailleur Haute Couture',
      description:
          'Tailleur structuré en brocart doré, lignes épurées et finitions '
          'couture. La quintessence du style corporate d\'exception.',
      category: ProductCategory.tailleur,
      badge: ProductBadge.nouveaute,
      imageUrls: [
        'https://picsum.photos/seed/aube1/800/1000',
        'https://picsum.photos/seed/aube2/800/1000',
      ],
      viewCount: 23,
    ),
  ];

  List<ProductModel> get products => List.unmodifiable(_products);

  List<ProductModel> get activeProducts =>
      _products.where((p) => p.isActive).toList();

  List<ProductModel> get featuredProducts =>
      activeProducts.take(4).toList();

  List<ProductModel> get favoriteProducts =>
      _products.where((p) => p.isFavorite).toList();

  List<ProductModel> byCategory(ProductCategory cat) =>
      activeProducts.where((p) => p.category == cat).toList();

  ProductModel? findById(String id) =>
      _products.where((p) => p.id == id).firstOrNull;

  void toggleFavorite(String productId) {
    final idx = _products.indexWhere((p) => p.id == productId);
    if (idx != -1) {
      _products[idx] = _products[idx].copyWith(
        isFavorite: !_products[idx].isFavorite,
      );
      notifyListeners();
    }
  }

  void toggleActive(String productId) {
    final idx = _products.indexWhere((p) => p.id == productId);
    if (idx != -1) {
      _products[idx] = _products[idx].copyWith(
        isActive: !_products[idx].isActive,
      );
      notifyListeners();
    }
  }

  void addProduct(ProductModel product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }
}
