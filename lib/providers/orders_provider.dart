import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../models/custom_request_model.dart';

class OrdersProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [
    const OrderModel(
      id: 'o1',
      reference: 'VC-2025-0042',
      clientName: 'Amina Kabila',
      productName: 'Nuit Étoilée',
      productImageUrl: 'https://picsum.photos/seed/nuit1/200/200',
      paymentMethod: PaymentMethod.mPesa,
      status: OrderStatus.enCours,
      createdAt: 'il y a 2h',
    ),
    const OrderModel(
      id: 'o2',
      reference: 'VC-2025-0043',
      clientName: 'Chiara Moretti',
      productName: 'Lagon Bleu',
      productImageUrl: 'https://picsum.photos/seed/lagon1/200/200',
      paymentMethod: PaymentMethod.orangeMoney,
      status: OrderStatus.nouveau,
      createdAt: 'il y a 5h',
    ),
    const OrderModel(
      id: 'o3',
      reference: 'VC-2025-0031',
      clientName: 'Marie Ngozi',
      productName: 'Soleil Rouge',
      productImageUrl: 'https://picsum.photos/seed/soleil1/200/200',
      paymentMethod: PaymentMethod.carteBancaire,
      status: OrderStatus.livre,
      createdAt: '18 jan.',
      deliveredAt: '25 jan.',
    ),
    const OrderModel(
      id: 'o4',
      reference: 'VC-2025-0028',
      clientName: 'Fatou Diallo',
      productName: 'Harmonie',
      productImageUrl: 'https://picsum.photos/seed/harmonie1/200/200',
      paymentMethod: PaymentMethod.africellMoney,
      status: OrderStatus.livre,
      createdAt: '15 jan.',
      deliveredAt: '20 jan.',
    ),
  ];

  final List<CustomRequestModel> _customRequests = [
    const CustomRequestModel(
      id: 'cr1',
      clientName: 'Chiara Moretti',
      garmentType: 'Robe de soirée',
      occasion: 'Gala',
      delai: '3 mois',
      message:
          'Je recherche une robe longue pour un gala d\'ambassade. Je préfère '
          'les tons noir et or avec des détails brodés.',
      receivedAt: 'il y a 5h',
      status: CustomRequestStatus.nouvelle,
    ),
    const CustomRequestModel(
      id: 'cr2',
      clientName: 'Amina Kabila',
      garmentType: 'Kaftan',
      occasion: 'Mariage',
      delai: '2 mois',
      message: 'Kaftan pour mariage traditionnel, coloris ivoire et doré.',
      receivedAt: 'il y a 2j',
      status: CustomRequestStatus.enCours,
    ),
    const CustomRequestModel(
      id: 'cr3',
      clientName: 'Marie Ngozi',
      garmentType: 'Tailleur',
      occasion: 'Corporate',
      delai: '1 mois',
      message: 'Tailleur strict pour réunion d\'affaires internationale.',
      receivedAt: '10 jan.',
      status: CustomRequestStatus.termine,
    ),
  ];

  List<OrderModel> get orders => List.unmodifiable(_orders);
  List<CustomRequestModel> get customRequests => List.unmodifiable(_customRequests);

  List<OrderModel> get newOrders =>
      _orders.where((o) => o.status == OrderStatus.nouveau).toList();
  List<OrderModel> get inProgressOrders =>
      _orders.where((o) => o.status == OrderStatus.enCours).toList();
  List<OrderModel> get deliveredOrders =>
      _orders.where((o) => o.status == OrderStatus.livre).toList();

  List<OrderModel> clientOrders(String clientName) =>
      _orders.where((o) => o.clientName == clientName).toList();

  List<CustomRequestModel> clientRequests(String clientName) =>
      _customRequests.where((r) => r.clientName == clientName).toList();

  String addOrder({
    required String clientName,
    required String productName,
    required PaymentMethod paymentMethod,
    String? productImageUrl,
  }) {
    final ref =
        'VC-${DateTime.now().year}-${(_orders.length + 1).toString().padLeft(4, '0')}';
    _orders.add(OrderModel(
      id: 'o${DateTime.now().millisecondsSinceEpoch}',
      reference: ref,
      clientName: clientName,
      productName: productName,
      productImageUrl: productImageUrl,
      paymentMethod: paymentMethod,
      status: OrderStatus.nouveau,
      createdAt: 'à l\'instant',
    ));
    notifyListeners();
    return ref;
  }

  void replyToRequest(String requestId, String reply) {
    final idx = _customRequests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      final r = _customRequests[idx];
      _customRequests[idx] = CustomRequestModel(
        id: r.id,
        clientName: r.clientName,
        garmentType: r.garmentType,
        occasion: r.occasion,
        delai: r.delai,
        message: r.message,
        receivedAt: r.receivedAt,
        status: CustomRequestStatus.enCours,
        adminReply: reply,
      );
      notifyListeners();
    }
  }

  void addCustomRequest(CustomRequestModel request) {
    _customRequests.add(request);
    notifyListeners();
  }
}
