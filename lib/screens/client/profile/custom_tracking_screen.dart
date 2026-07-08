import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/custom_request_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/orders_provider.dart';
import '../../../providers/products_provider.dart';
import '../../../widgets/app_image.dart';
import '../../../widgets/gold_divider.dart';

class CustomTrackingScreen extends StatelessWidget {
  const CustomTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final requests = context.watch<OrdersProvider>()
        .clientRequests(auth.user?.name ?? '');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('SUIVI SUR-MESURE',
            style: TextStyle(letterSpacing: 2, fontSize: 11)),
      ),
      body: requests.isEmpty
          ? const Center(
              child: Text('Aucune demande en cours',
                  style: TextStyle(color: AppColors.textSecondary)))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, i) => _RequestCard(
                request: requests[i],
                onTrack: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _TrackingDetailScreen(request: requests[i]),
                  ),
                ),
              ),
            ),
    );
  }
}

// ── Request summary card ───────────────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  final CustomRequestModel request;
  final VoidCallback onTrack;
  const _RequestCard({required this.request, required this.onTrack});

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
      onTap: onTrack,
      child: Container(
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
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _statusColor.withOpacity(0.4)),
                  ),
                  child: Text(request.statusLabel,
                      style: TextStyle(
                          color: _statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const GoldDivider(),
            const SizedBox(height: 10),
            _InfoRow('Occasion', request.occasion),
            _InfoRow('Délai', request.delai),
            _InfoRow('Reçu le', request.receivedAt),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.goldFaint,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.gold.withOpacity(0.4)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Voir la progression',
                          style: TextStyle(color: AppColors.gold, fontSize: 12)),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward, color: AppColors.gold, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Text('$label : ',
              style:
                  const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          Text(value,
              style: const TextStyle(color: AppColors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

// ── 4-step tracking detail ─────────────────────────────────────────────────────

class _TrackingDetailScreen extends StatelessWidget {
  final CustomRequestModel request;
  const _TrackingDetailScreen({required this.request});

  int get _currentStep {
    switch (request.status) {
      case CustomRequestStatus.nouvelle: return 0; // Conception en cours
      case CustomRequestStatus.enCours:  return 2; // Couture en cours
      case CustomRequestStatus.termine:  return 4; // Tout terminé
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = context.read<ProductsProvider>().products;
    final coverImage =
        products.isNotEmpty ? products.first.imageUrls.firstOrNull : null;

    final steps = [
      _Step(
        title: 'Conception',
        doneLabel: 'Patron finalisé · 12 jan.',
        progressLabel: 'Patron en cours de finalisation...',
        pendingLabel: 'En attente',
      ),
      _Step(
        title: 'Essayage',
        doneLabel: 'Effectué · 18 jan.',
        progressLabel: 'Rendez-vous à confirmer',
        pendingLabel: 'En attente',
      ),
      _Step(
        title: 'Couture',
        doneLabel: 'Terminée',
        progressLabel: 'En cours...',
        pendingLabel: 'En attente',
      ),
      _Step(
        title: 'Livraison',
        doneLabel: 'Livrée',
        progressLabel: 'Prévue bientôt',
        pendingLabel: 'Prévue · 28 jan.',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Suivi Sur-Mesure',
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            Text(
              '${request.garmentType.toUpperCase()} · RÉF. VC-2025-0042',
              style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  letterSpacing: 1),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            if (coverImage != null)
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.surface,
                ),
                clipBehavior: Clip.hardEdge,
                child: AppImage(imageUrl: coverImage, fit: BoxFit.cover),
              )
            else
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Center(
                  child: Icon(Icons.checkroom_outlined,
                      size: 48, color: AppColors.textMuted),
                ),
              ),
            const SizedBox(height: 8),
            // Dot indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Container(
                  width: i == 0 ? 18 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i == 0 ? AppColors.gold : AppColors.textMuted,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Progression title
            const Text('PROGRESSION',
                style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 11,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),

            // 4-step timeline
            ...steps.asMap().entries.map((entry) {
              final idx = entry.key;
              final step = entry.value;
              final isDone = idx < _currentStep;
              final isActive = idx == _currentStep;
              final isPending = idx > _currentStep;
              final isLast = idx == steps.length - 1;

              return _StepRow(
                step: step,
                isDone: isDone,
                isActive: isActive,
                isPending: isPending,
                isLast: isLast,
              );
            }),

            const SizedBox(height: 28),
            const GoldDivider(),
            const SizedBox(height: 20),

            // Admin reply if available
            if (request.adminReply != null) ...[
              const Text('MESSAGE DE L\'ATELIER',
                  style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 11,
                      letterSpacing: 2)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.goldFaint,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                ),
                child: Text(request.adminReply!,
                    style: const TextStyle(
                        color: AppColors.white, fontSize: 14, height: 1.5)),
              ),
              const SizedBox(height: 20),
            ],

            // Original request details
            const Text('VOTRE DEMANDE',
                style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    letterSpacing: 2)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Text(request.message,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.5)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _Step {
  final String title;
  final String doneLabel;
  final String progressLabel;
  final String pendingLabel;
  const _Step({
    required this.title,
    required this.doneLabel,
    required this.progressLabel,
    required this.pendingLabel,
  });
}

class _StepRow extends StatelessWidget {
  final _Step step;
  final bool isDone;
  final bool isActive;
  final bool isPending;
  final bool isLast;

  const _StepRow({
    required this.step,
    required this.isDone,
    required this.isActive,
    required this.isPending,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator column
          SizedBox(
            width: 32,
            child: Column(
              children: [
                // Circle
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? AppColors.gold
                        : isActive
                            ? AppColors.background
                            : AppColors.surface,
                    border: Border.all(
                      color: isDone || isActive
                          ? AppColors.gold
                          : AppColors.cardBorder,
                      width: isActive ? 2.5 : 1.5,
                    ),
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check,
                            size: 16, color: AppColors.background)
                        : isActive
                            ? Container(
                                width: 10, height: 10,
                                decoration: const BoxDecoration(
                                  color: AppColors.gold,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.cardBorder),
                                ),
                              ),
                  ),
                ),
                // Connector line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isDone
                          ? AppColors.gold.withOpacity(0.5)
                          : AppColors.cardBorder,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Step content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.title,
                      style: TextStyle(
                        color: isPending
                            ? AppColors.textMuted
                            : AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      )),
                  const SizedBox(height: 4),
                  Text(
                    isDone
                        ? step.doneLabel
                        : isActive
                            ? step.progressLabel
                            : step.pendingLabel,
                    style: TextStyle(
                      color: isActive
                          ? AppColors.gold
                          : AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
