import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/custom_request_model.dart';
import '../../../providers/orders_provider.dart';
import '../../../widgets/gold_button.dart';
import '../../../widgets/gold_divider.dart';

class AdminSurMesureScreen extends StatefulWidget {
  const AdminSurMesureScreen({super.key});

  @override
  State<AdminSurMesureScreen> createState() => _AdminSurMesureScreenState();
}

class _AdminSurMesureScreenState extends State<AdminSurMesureScreen> {
  String? _activeRequestId;
  final _replyCtrl = TextEditingController();

  @override
  void dispose() {
    _replyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requests = context.watch<OrdersProvider>().customRequests;
    final active = _activeRequestId != null
        ? requests.firstWhere((r) => r.id == _activeRequestId,
            orElse: () => requests.first)
        : requests.isNotEmpty
            ? requests.first
            : null;
    final others = requests
        .where((r) => r.id != (active?.id ?? ''))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text('Sur-Mesure',
                  style: Theme.of(context).textTheme.headlineLarge),
              Text('${requests.length} DEMANDES',
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11, letterSpacing: 2)),
              const SizedBox(height: 16),
              const GoldDivider(),
              const SizedBox(height: 20),

              // Active request card
              if (active != null) _ActiveRequestCard(
                request: active,
                replyCtrl: _replyCtrl,
                onSend: () {
                  if (_replyCtrl.text.trim().isEmpty) return;
                  context.read<OrdersProvider>().replyToRequest(
                        active.id,
                        _replyCtrl.text.trim(),
                      );
                  _replyCtrl.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.surface,
                      content: Text('Réponse envoyée',
                          style: TextStyle(color: AppColors.white)),
                    ),
                  );
                },
              ),

              if (others.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text('AUTRES DEMANDES',
                    style: TextStyle(
                        color: AppColors.gold, fontSize: 11, letterSpacing: 2.5)),
                const SizedBox(height: 14),
                ...others.map((r) => _OtherRequestRow(
                      request: r,
                      onTap: () => setState(() => _activeRequestId = r.id),
                    )),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveRequestCard extends StatelessWidget {
  final CustomRequestModel request;
  final TextEditingController replyCtrl;
  final VoidCallback onSend;

  const _ActiveRequestCard({
    required this.request,
    required this.replyCtrl,
    required this.onSend,
  });

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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(request.clientName,
                  style: const TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 18)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _statusColor.withOpacity(0.4)),
                ),
                child: Text(request.statusLabel,
                    style: TextStyle(
                        color: _statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Info grid
          Row(
            children: [
              Expanded(child: _InfoBox(label: 'TYPE', value: request.garmentType)),
              const SizedBox(width: 10),
              Expanded(child: _InfoBox(label: 'OCCASION', value: request.occasion)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _InfoBox(label: 'DÉLAI', value: request.delai)),
              const SizedBox(width: 10),
              Expanded(child: _InfoBox(label: 'REÇU', value: request.receivedAt)),
            ],
          ),
          const SizedBox(height: 14),

          // Client message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('MESSAGE CLIENT',
                    style: TextStyle(
                        color: AppColors.textMuted, fontSize: 10, letterSpacing: 2)),
                const SizedBox(height: 8),
                Text(request.message,
                    style: const TextStyle(
                        color: AppColors.white, fontSize: 13, height: 1.5)),
              ],
            ),
          ),

          if (request.adminReply != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.goldFaint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(request.adminReply!,
                  style: const TextStyle(color: AppColors.gold, fontSize: 13)),
            ),
          ],

          const SizedBox(height: 14),

          // Reply field
          TextFormField(
            controller: replyCtrl,
            maxLines: 3,
            style: const TextStyle(color: AppColors.white),
            decoration: InputDecoration(
              hintText: 'Répondre à ${request.clientName.split(' ').first}...',
              fillColor: AppColors.card,
            ),
          ),
          const SizedBox(height: 12),
          GoldButton(label: 'Envoyer la réponse', onPressed: onSend),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 9, letterSpacing: 1.5)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}

class _OtherRequestRow extends StatelessWidget {
  final CustomRequestModel request;
  final VoidCallback onTap;

  const _OtherRequestRow({required this.request, required this.onTap});

  Color get _statusColor {
    switch (request.status) {
      case CustomRequestStatus.nouvelle: return AppColors.info;
      case CustomRequestStatus.enCours:  return AppColors.warning;
      case CustomRequestStatus.termine:  return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request.clientName,
                    style: const TextStyle(
                        color: AppColors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(
                    '${request.garmentType} · ${request.occasion} · ${request.delai}',
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _statusColor.withOpacity(0.4)),
              ),
              child: Text(request.statusLabel,
                  style: TextStyle(color: _statusColor, fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }
}
