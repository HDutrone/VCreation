enum CustomRequestStatus { nouvelle, enCours, termine }

class CustomRequestModel {
  final String id;
  final String clientName;
  final String garmentType;
  final String occasion;
  final String delai;
  final String message;
  final String receivedAt;
  final CustomRequestStatus status;
  final String? adminReply;
  final bool isOverdue;

  const CustomRequestModel({
    required this.id,
    required this.clientName,
    required this.garmentType,
    required this.occasion,
    required this.delai,
    required this.message,
    required this.receivedAt,
    required this.status,
    this.adminReply,
    this.isOverdue = false,
  });

  String get statusLabel {
    switch (status) {
      case CustomRequestStatus.nouvelle:  return 'Nouvelle';
      case CustomRequestStatus.enCours:   return 'En cours';
      case CustomRequestStatus.termine:   return 'Terminé';
    }
  }
}
