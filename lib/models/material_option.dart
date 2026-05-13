class MaterialOption {
  const MaterialOption({
    required this.id,
    required this.name,
    required this.isDefault,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final bool isDefault;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory MaterialOption.fromJson(Map<String, dynamic> json) {
    return MaterialOption(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      isDefault: json['is_default'] == true,
      isActive: json['is_active'] == true,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }
}
