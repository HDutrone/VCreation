import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/custom_request_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/orders_provider.dart';
import '../../../widgets/gold_divider.dart';

class CustomTrackingScreen extends StatelessWidget {
  const CustomTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final requests = context.watch<OrdersProvider>()
        .clientRequests(auth.user?.displayName ?? '');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('DEMANDES SUR-MESURE',
            style: TextStyle(letterSpacing: 2, fontSize: 11)),
      ),
      body: requests.isEmpty
          ? const Center(
              child: Text('Aucune demande',
                  style: TextStyle(color: AppColors.textSecondary)))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, i) => _RequestCard(request: requests[i]),
            ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final CustomRequestModel request;
  const _RequestCard({required this.request});

  Color get _statusColor {
    switch (request.status) {
      case CustomRequestStatus.nouvelle: return AppColors.info;
      case CustomRequestStatus.enCours:  return AppColors.warning;
      case CustomRequestStatus.termine:  return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(request.garmentType,
                  style: const TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _statusColor.withOpacity(0.4)),
                ),
                child: Text(request.statusLabel,
                    style: TextStyle(
                        color: _statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const GoldDivider(),
          const SizedBox(height: 10),
          _InfoRow('Occasion', request.occasion),
          _InfoRow('Délai souhaité', request.delai),
          _InfoRow('Reçu', request.receivedAt),
          const SizedBox(height: 10),
          Text(request.message,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
          if (request.adminReply != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.goldFaint,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gold.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('RÉPONSE DE L\'ATELIER',
                      style: TextStyle(
                          color: AppColors.gold, fontSize: 10, letterSpacing: 2)),
                  const SizedBox(height: 6),
                  Text(request.adminReply!,
                      style: const TextStyle(
                          color: AppColors.white, fontSize: 13, height: 1.5)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text('$label : ',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          Text(value,
              style: const TextStyle(color: AppColors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
