class Driver {
  const Driver({
    required this.id,
    required this.phone,
    required this.name,
    required this.latestPhotoUrl,
    required this.latestPhotoKey,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String phone;
  final String name;
  final String? latestPhotoUrl;
  final String? latestPhotoKey;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      latestPhotoUrl: _emptyToNull(json['latest_photo_url']),
      latestPhotoKey: _emptyToNull(json['latest_photo_key']),
      isActive: json['is_active'] == true,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }

  static String? _emptyToNull(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }
}

class DriverSearchResult {
  const DriverSearchResult({
    required this.found,
    required this.message,
    required this.driver,
  });

  final bool found;
  final String message;
  final Driver? driver;
}
