part of '../main.dart';

class GateEntrySubmitResult {
  const GateEntrySubmitResult({
    required this.message,
    required this.approval,
    required this.entry,
    required this.driver,
    required this.material,
  });

  final String message;
  final ApprovalResult approval;
  final TruckEntry entry;
  final Driver? driver;
  final MaterialOption? material;

  factory GateEntrySubmitResult.fromJson(Map<String, dynamic> json) {
    final entryJson = json['entry'];
    final approvalJson = json['approval'];
    final driverJson = json['driver'];
    final materialJson = json['material'];
    final entry =
        entryJson is Map<String, dynamic>
            ? TruckEntry.fromBackendJson(entryJson)
            : TruckEntry(
              driverName: '',
              driverPhone: '',
              truckNumber: '',
              materialType: '',
              temperature: 0,
              entryDateTime: DateTime.now(),
            );

    return GateEntrySubmitResult(
      message: json['message']?.toString() ?? '',
      approval:
          approvalJson is Map<String, dynamic>
              ? ApprovalResult.fromJson(approvalJson)
              : ApprovalResult.fallbackForTemperature(entry.temperature),
      entry: entry,
      driver:
          driverJson is Map<String, dynamic>
              ? Driver.fromJson(driverJson)
              : null,
      material:
          materialJson is Map<String, dynamic>
              ? MaterialOption.fromJson(materialJson)
              : null,
    );
  }
}
