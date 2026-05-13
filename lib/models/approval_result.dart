part of '../main.dart';

class ApprovalResult {
  const ApprovalResult({
    required this.status,
    required this.temperatureStatus,
    required this.isApproved,
    required this.title,
    required this.message,
    required this.normalRange,
  });

  final String status;
  final String temperatureStatus;
  final bool isApproved;
  final String title;
  final String message;
  final String normalRange;

  factory ApprovalResult.fromJson(Map<String, dynamic> json) {
    return ApprovalResult(
      status: json['status']?.toString() ?? '',
      temperatureStatus: json['temperature_status']?.toString() ?? '',
      isApproved: json['is_approved'] == true,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      normalRange: json['normal_range']?.toString() ?? '',
    );
  }

  factory ApprovalResult.fallbackForTemperature(double temperature) {
    final isApproved = TruckEntry.isTemperatureNormal(temperature);
    return ApprovalResult(
      status: isApproved ? 'approved' : 'not_approved',
      temperatureStatus: isApproved ? 'normal' : 'abnormal',
      isApproved: isApproved,
      title: isApproved ? 'Approved' : 'Not Approved',
      message:
          isApproved
              ? 'Driver temperature is within the normal range.'
              : 'Driver temperature is outside the normal range.',
      normalRange: '97 F to 99 F',
    );
  }
}
