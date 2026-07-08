enum OrderStatus { nouveau, enCours, livre }
enum PaymentMethod { carteBancaire, mPesa, airtelMoney, orangeMoney, africellMoney }

class OrderModel {
  final String id;
  final String reference;
  final String clientName;
  final String productName;
  final String? productImageUrl;
  final PaymentMethod paymentMethod;
  final OrderStatus status;
  final String createdAt;
  final String? deliveredAt;

  const OrderModel({
    required this.id,
    required this.reference,
    required this.clientName,
    required this.productName,
    this.productImageUrl,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.deliveredAt,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.nouveau:   return 'Nouveau';
      case OrderStatus.enCours:   return 'En cours';
      case OrderStatus.livre:     return 'Livré';
    }
  }

  String get paymentLabel {
    switch (paymentMethod) {
      case PaymentMethod.carteBancaire: return 'Carte';
      case PaymentMethod.mPesa:         return 'M-Pesa';
      case PaymentMethod.airtelMoney:   return 'Airtel Money';
      case PaymentMethod.orangeMoney:   return 'Orange Money';
      case PaymentMethod.africellMoney: return 'Africell Money';
    }
  }
}
