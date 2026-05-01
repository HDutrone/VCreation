import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => List.unmodifiable(_items);
  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;

  bool isInCart(String productId) =>
      _items.any((i) => i.product.id == productId);

  void addItem(ProductModel product, {String? size, bool isSurMesure = false}) {
    if (isInCart(product.id)) return;
    _items.add(CartItemModel(
      id: 'ci${DateTime.now().millisecondsSinceEpoch}',
      product: product,
      size: size,
      isSurMesure: isSurMesure,
      consultationStatus: isSurMesure ? 'Consultation en cours' : null,
    ));
    notifyListeners();
  }

  void removeItem(String cartItemId) {
    _items.removeWhere((i) => i.id == cartItemId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
