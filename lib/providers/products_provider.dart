import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class ProductsProvider extends ChangeNotifier {
  final List<ProductModel> _products = [
    const ProductModel(
      id: 'p1',
      name: 'Brume Turquoise',
      subtitle: 'Ensemble Haute Couture',
      description:
          'Robe courte en broderie anglaise turquoise, ceinturée d\'un nœud satiné. '
          'Finitions impeccables révélant un savoir-faire artisanal unique. '
          'Quatre vues pour découvrir chaque détail de cette pièce aérienne.',
      category: ProductCategory.ensemble,
      badge: ProductBadge.surMesureDispo,
      imageUrls: [
        'assets/images/models/modele1/photo1.jpg',
        'assets/images/models/modele1/photo2.jpg',
        'assets/images/models/modele1/photo3.jpg',
        'assets/images/models/modele1/photo4.jpg',
      ],
      viewCount: 74,
    ),
    const ProductModel(
      id: 'p2',
      name: 'Flamme Wax',
      subtitle: 'Robe Haute Couture',
      description:
          'Longue robe rouge ornée d\'appliqués circulaires en tissu wax multicolore. '
          'Mélange audacieux des traditions couture et du patrimoine africain. '
          'Six angles pour révéler toute la richesse de cette création unique.',
      category: ProductCategory.robe,
      badge: ProductBadge.surMesureDispo,
      imageUrls: [
        'assets/images/models/modele2/photo1.jpg',
        'assets/images/models/modele2/photo2.jpg',
        'assets/images/models/modele2/photo3.jpg',
        'assets/images/models/modele2/photo4.jpg',
        'assets/images/models/modele2/photo5.jpg',
        'assets/images/models/modele2/photo6.jpg',
      ],
      viewCount: 112,
    ),
    const ProductModel(
      id: 'p3',
      name: 'Nuit Étoilée',
      subtitle: 'Robe de Soirée',
      description:
          'Robe de soirée en franges noires superposées, travail artisanal minutieux '
          'réalisé entièrement à la main. Inspirée du jazz de l\'ère Art Déco, '
          'cette pièce signature allie élégance structurée et mouvement perpétuel.',
      category: ProductCategory.robe,
      badge: ProductBadge.pieceSignature,
      imageUrls: [
        'assets/images/models/modele3/photo1.jpg',
        'assets/images/models/modele3/photo2.jpg',
        'assets/images/models/modele3/photo3.jpg',
        'assets/images/models/modele3/photo4.jpg',
        'assets/images/models/modele3/photo5.jpg',
        'assets/images/models/modele3/photo6.jpg',
        'assets/images/models/modele3/photo7.jpg',
        'assets/images/models/modele3/photo8.jpg',
        'assets/images/models/modele3/photo9.jpg',
      ],
      viewCount: 186,
    ),
    const ProductModel(
      id: 'p4',
      name: 'Aube Impériale',
      subtitle: 'Robe Haute Couture',
      description:
          'Création spectaculaire dorée et verte aux épaules sculptées en papillon. '
          'Broderies impériales à la main, pièce unique de haute couture d\'exception. '
          'Une silhouette royale qui incarne l\'essence même du luxe africain.',
      category: ProductCategory.robe,
      badge: ProductBadge.pieceSignature,
      imageUrls: [
        'assets/images/models/modele4/photo1.jpg',
        'assets/images/models/modele4/photo2.jpg',
        'assets/images/models/modele4/photo3.jpg',
        'assets/images/models/modele4/photo4.jpg',
      ],
      viewCount: 93,
    ),
    const ProductModel(
      id: 'p5',
      name: 'Soleil d\'Or',
      subtitle: 'Ensemble Haute Couture',
      description:
          'Ensemble deux-pièces en broderie anglaise jaune ensoleillée, '
          'manches cascades à volants superposés. Légèreté et féminité à l\'état pur. '
          'Une création lumineuse qui célèbre la femme dans toute sa splendeur.',
      category: ProductCategory.ensemble,
      badge: ProductBadge.nouveaute,
      imageUrls: [
        'assets/images/models/modele5/photo1.jpg',
        'assets/images/models/modele5/photo2.jpg',
        'assets/images/models/modele5/photo3.jpg',
        'assets/images/models/modele5/photo4.jpg',
      ],
      viewCount: 58,
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
