class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.priority,
    required this.isRead,
    required this.createdAt,
    this.driverName,
    this.driverPhone,
    this.truckNumber,
    this.temperatureFahrenheit,
  });

  final String id;
  final String type;
  final String title;
  final String message;
  final String priority;
  final bool isRead;
  final DateTime? createdAt;
  final String? driverName;
  final String? driverPhone;
  final String? truckNumber;
  final double? temperatureFahrenheit;

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      priority: json['priority']?.toString() ?? '',
      isRead: json['is_read'] == true,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      driverName: _emptyToNull(json['driver_name']),
      driverPhone: _emptyToNull(json['driver_phone']),
      truckNumber: _emptyToNull(json['truck_number']),
      temperatureFahrenheit: _parseDouble(json['temperature_fahrenheit']),
    );
  }

  static String? _emptyToNull(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }
}
