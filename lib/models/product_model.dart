enum ProductCategory { robe, kaftan, tailleur, ensemble }
enum ProductBadge { pieceSignature, surMesureDispo, nouveaute }

class ProductModel {
  final String id;
  final String name;
  final String subtitle;
  final String description;
  final ProductCategory category;
  final ProductBadge badge;
  final List<String> imageUrls;
  final double? price;
  final int viewCount;
  final bool isActive;
  final bool isFavorite;

  const ProductModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.badge,
    required this.imageUrls,
    this.price,
    this.viewCount = 0,
    this.isActive = true,
    this.isFavorite = false,
  });

  String get categoryLabel {
    switch (category) {
      case ProductCategory.robe:    return 'ROBE HAUTE COUTURE';
      case ProductCategory.kaftan:  return 'KAFTAN HAUTE COUTURE';
      case ProductCategory.tailleur: return 'TAILLEUR HAUTE COUTURE';
      case ProductCategory.ensemble: return 'ENSEMBLE HAUTE COUTURE';
    }
  }

  String get categoryShort {
    switch (category) {
      case ProductCategory.robe:    return 'ROBE';
      case ProductCategory.kaftan:  return 'KAFTAN';
      case ProductCategory.tailleur: return 'TAILLEUR';
      case ProductCategory.ensemble: return 'ENSEMBLE';
    }
  }

  String get badgeLabel {
    switch (badge) {
      case ProductBadge.pieceSignature:  return 'Pièce signature';
      case ProductBadge.surMesureDispo:  return 'Sur-mesure dispo.';
      case ProductBadge.nouveaute:       return 'Nouveauté';
    }
  }

  String get priceLabel => price != null ? '\$${price!.toStringAsFixed(0)}' : 'Sur devis';

  String get photoCount => imageUrls.length == 1 ? '1 photo' : '${imageUrls.length} photos';

  ProductModel copyWith({bool? isFavorite, bool? isActive}) {
    return ProductModel(
      id: id,
      name: name,
      subtitle: subtitle,
      description: description,
      category: category,
      badge: badge,
      imageUrls: imageUrls,
      price: price,
      viewCount: viewCount,
      isActive: isActive ?? this.isActive,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
