import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/user_model.dart';
import '../../../widgets/gold_divider.dart';

class AdminClientsScreen extends StatefulWidget {
  const AdminClientsScreen({super.key});

  @override
  State<AdminClientsScreen> createState() => _AdminClientsScreenState();
}

class _AdminClientsScreenState extends State<AdminClientsScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  final List<_ClientData> _clients = const [
    _ClientData(
      name: 'Amina Kabila',
      subtitle: '3 commandes · 1 sur-mesure en cours',
      isPrivate: true,
      isBanned: false,
    ),
    _ClientData(
      name: 'Chiara Moretti',
      subtitle: '1 commande · demande nouvelle',
      isPrivate: false,
      isBanned: false,
    ),
    _ClientData(
      name: 'Fatou Diallo',
      subtitle: '2 commandes · client fidèle',
      isPrivate: true,
      isBanned: false,
    ),
    _ClientData(
      name: 'Marie Ngozi',
      subtitle: '1 commande livrée',
      isPrivate: false,
      isBanned: false,
    ),
    _ClientData(
      name: 'Aïcha Traoré',
      subtitle: '0 commande · inscrite récemment',
      isPrivate: false,
      isBanned: false,
    ),
  ];

  List<_ClientData> get _filtered => _query.isEmpty
      ? _clients
      : _clients
          .where((c) =>
              c.name.toLowerCase().contains(_query.toLowerCase()))
          .toList();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text('Clients',
                  style: Theme.of(context).textTheme.headlineLarge),
              Text('${_clients.length} CLIENTS',
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11, letterSpacing: 2)),
              const SizedBox(height: 16),
              const GoldDivider(),
              const SizedBox(height: 16),

              // Search bar
              TextFormField(
                controller: _searchCtrl,
                style: const TextStyle(color: AppColors.white),
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  hintText: 'Rechercher un client...',
                  prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: _filtered.isEmpty
                    ? const Center(
                        child: Text('Aucun client trouvé',
                            style: TextStyle(color: AppColors.textSecondary)),
                      )
                    : ListView.separated(
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) =>
                            const Divider(color: AppColors.divider),
                        itemBuilder: (_, i) => _ClientRow(
                          client: _filtered[i],
                          onBan: () => _confirmBan(context, _filtered[i]),
                          onDelete: () => _confirmDelete(context, _filtered[i]),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmBan(BuildContext ctx, _ClientData client) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Bannir ${client.name.split(' ').first}?',
            style: const TextStyle(color: AppColors.white)),
        content: const Text(
            'Le client sera bloqué et ne pourra plus accéder à l\'application.',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler', style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Bannir', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, _ClientData client) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Supprimer ${client.name.split(' ').first}?',
            style: const TextStyle(color: AppColors.white)),
        content: const Text(
            'Cette action est irréversible. Toutes les données du client seront supprimées.',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler', style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Supprimer', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _ClientData {
  final String name;
  final String subtitle;
  final bool isPrivate;
  final bool isBanned;

  const _ClientData({
    required this.name,
    required this.subtitle,
    required this.isPrivate,
    required this.isBanned,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }
}

class _ClientRow extends StatelessWidget {
  final _ClientData client;
  final VoidCallback onBan;
  final VoidCallback onDelete;

  const _ClientRow({required this.client, required this.onBan, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: client.isPrivate ? AppColors.gold : AppColors.cardBorder,
                width: client.isPrivate ? 1.5 : 1,
              ),
              color: client.isPrivate ? AppColors.goldFaint : AppColors.surface,
            ),
            child: Center(
              child: Text(client.initials,
                  style: TextStyle(
                      color: client.isPrivate
                          ? AppColors.gold
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(client.name,
                    style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                const SizedBox(height: 3),
                Text(client.subtitle,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
          // Badge + menu
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: client.isPrivate
                      ? AppColors.goldFaint
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: client.isPrivate
                        ? AppColors.gold.withOpacity(0.4)
                        : AppColors.cardBorder,
                  ),
                ),
                child: Text(
                  client.isPrivate ? 'Privé' : 'Standard',
                  style: TextStyle(
                      color: client.isPrivate
                          ? AppColors.gold
                          : AppColors.textSecondary,
                      fontSize: 11),
                ),
              ),
              const SizedBox(height: 4),
              PopupMenuButton<String>(
                color: AppColors.surface,
                icon: const Icon(Icons.more_vert, color: AppColors.textMuted, size: 18),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'ban',
                    child: Row(
                      children: [
                        Icon(Icons.block, color: AppColors.warning, size: 18),
                        SizedBox(width: 8),
                        Text('Bannir', style: TextStyle(color: AppColors.white)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: AppColors.error, size: 18),
                        SizedBox(width: 8),
                        Text('Supprimer', style: TextStyle(color: AppColors.white)),
                      ],
                    ),
                  ),
                ],
                onSelected: (v) => v == 'ban' ? onBan() : onDelete(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
