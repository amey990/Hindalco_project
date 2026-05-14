class ManagedUser {
  const ManagedUser({
    required this.id,
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
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String? siteName;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ManagedUser.fromJson(Map<String, dynamic> json) {
    return ManagedUser(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      role: json['role']?.toString().trim().toLowerCase() ?? '',
      siteName: json['site_name']?.toString(),
      isActive: json['is_active'] == true,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }

  String get displayRole {
    return switch (role) {
      'supervisor' => 'Supervisor',
      'security' => 'Security Guard',
      _ => _titleCase(role),
    };
  }

  String get statusLabel => isActive ? 'Active' : 'Disabled';

  String get initials {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty);
    final value = words.take(2).map((word) => word[0].toUpperCase()).join();
    return value.isEmpty ? 'U' : value;
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
