class AppUser {
  const AppUser({
    required this.id,
    required this.cognitoSub,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.siteName,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String cognitoSub;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String? siteName;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id']?.toString() ?? '',
      cognitoSub: json['cognito_sub']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      role: json['role']?.toString() ?? '',
      siteName: json['site_name']?.toString(),
      isActive: json['is_active'] == true,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }

  String get initials {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty);
    final value = words.take(2).map((word) => word[0].toUpperCase()).join();
    return value.isEmpty ? 'U' : value;
  }

  String get displayRole {
    return switch (role.toLowerCase()) {
      'supervisor' => 'Supervisor',
      'security' => 'Security',
      'admin' => 'Admin',
      _ => _titleCase(role),
    };
  }

  static String _titleCase(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'User';
    }

    return trimmed
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) {
            return word;
          }
          return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
        })
        .join(' ');
  }
}
