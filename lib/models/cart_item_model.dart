import 'product_model.dart';

class CartItemModel {
  final String id;
  final ProductModel product;
  final String? size;
  final int quantity;
  final bool isSurMesure;
  final String? consultationStatus;

  const CartItemModel({
    required this.id,
    required this.product,
    this.size,
    this.quantity = 1,
    this.isSurMesure = false,
    this.consultationStatus,
  });

  String get typeLabel => isSurMesure ? 'Sur-mesure' : 'Pièce standard';
  String get priceLabel => product.priceLabel;
}
