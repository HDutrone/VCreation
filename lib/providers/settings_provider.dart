import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const _keyWhatsApp = 'whatsapp_number';

  String _whatsappNumber = '243810000000';

  String get whatsappNumber => _whatsappNumber;

  String get whatsappDisplay {
    final n = _whatsappNumber;
    if (n.length == 12 && n.startsWith('243')) {
      return '+${n.substring(0, 3)} ${n.substring(3, 6)} ${n.substring(6, 9)} ${n.substring(9)}';
    }
    return '+$n';
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _whatsappNumber = prefs.getString(_keyWhatsApp) ?? '243810000000';
    notifyListeners();
  }

  Future<void> setWhatsappNumber(String raw) async {
    final cleaned = raw.replaceAll(RegExp(r'\D'), '');
    if (cleaned.isEmpty) return;
    _whatsappNumber = cleaned;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyWhatsApp, cleaned);
    notifyListeners();
  }
}
