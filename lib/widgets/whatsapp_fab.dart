import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_colors.dart';
import '../providers/settings_provider.dart';

const _whatsappMessage =
    'Bonjour V Créations, je souhaite en savoir plus sur vos créations.';

class WhatsAppFab extends StatelessWidget {
  const WhatsAppFab({super.key});

  Future<void> _openWhatsApp(String number) async {
    final uri = Uri.parse(
      'https://wa.me/$number?text=${Uri.encodeComponent(_whatsappMessage)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final number = context.watch<SettingsProvider>().whatsappNumber;
    return FloatingActionButton(
      onPressed: () => _openWhatsApp(number),
      backgroundColor: const Color(0xFF25D366),
      elevation: 4,
      shape: const CircleBorder(),
      child: const Icon(Icons.chat_bubble, color: Colors.white, size: 26),
    );
  }
}

/// Banner card used on the Home screen
class WhatsAppBanner extends StatelessWidget {
  const WhatsAppBanner({super.key});

  Future<void> _openWhatsApp(String number) async {
    final uri = Uri.parse(
      'https://wa.me/$number?text=${Uri.encodeComponent(_whatsappMessage)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return GestureDetector(
      onTap: () => _openWhatsApp(settings.whatsappNumber),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble,
                color: Color(0xFF25D366),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contactez-nous sur WhatsApp',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    settings.whatsappDisplay,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
