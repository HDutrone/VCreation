enum UserRole { guest, client, admin }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;
  final String memberSince;
  final bool isPrivate;
  final bool isBanned;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.memberSince,
    this.isPrivate = false,
    this.isBanned = false,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }

  String get displayName {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0]} ${parts[1][0]}.';
    return name;
  }

  String get tier => isPrivate ? 'CLIENT PRIVÉ' : 'CLIENT STANDARD';
}
