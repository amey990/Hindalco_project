part of '../main.dart';

class RecordsModeToggle extends StatelessWidget {
  const RecordsModeToggle({
    required this.selectedMode,
    required this.onChanged,
    super.key,
  });

  final RecordsViewMode selectedMode;
  final ValueChanged<RecordsViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1BA7E1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: RecordsModeButton(
              label: 'All',
              isSelected: selectedMode == RecordsViewMode.all,
              isFirst: true,
              onTap: () => onChanged(RecordsViewMode.all),
            ),
          ),
          Container(width: 1, color: const Color(0xFF1BA7E1)),
          Expanded(
            child: RecordsModeButton(
              label: 'By user',
              isSelected: selectedMode == RecordsViewMode.byUser,
              onTap: () => onChanged(RecordsViewMode.byUser),
            ),
          ),
        ],
      ),
    );
  }
}

class RecordsModeButton extends StatelessWidget {
  const RecordsModeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isFirst = false,
    super.key,
  });

  final String label;
  final bool isSelected;
  final bool isFirst;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.horizontal(
      left: isFirst ? const Radius.circular(7) : Radius.zero,
      right: isFirst ? Radius.zero : const Radius.circular(7),
    );

    return Material(
      color: isSelected ? const Color(0xFFEAF6FC) : Colors.white,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color:
                  isSelected
                      ? const Color(0xFF1BA7E1)
                      : const Color(0xFF515A68),
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class DriverRecordSummary {
  const DriverRecordSummary({
    required this.latestEntry,
    required this.logs,
    this.logCount,
  });

  final TruckEntry latestEntry;
  final List<TruckEntry> logs;
  final int? logCount;

  int get totalLogs => logCount ?? logs.length;

  factory DriverRecordSummary.fromBackendJson(Map<String, dynamic> json) {
    final entry = TruckEntry(
      id: json['latest_entry_id']?.toString(),
      driverName: json['driver_name']?.toString() ?? '',
      driverPhone: json['driver_phone']?.toString() ?? '',
      truckNumber: json['latest_truck_number']?.toString() ?? '',
      materialType: json['latest_material_name']?.toString() ?? '',
      temperature: _parseDouble(json['latest_temperature']),
      entryDateTime:
          DateTime.tryParse(json['latest_entry_timestamp']?.toString() ?? '') ??
          DateTime.now(),
      driverPhotoPath: json['driver_photo_preview_url']?.toString(),
      temperatureStatus: json['latest_temperature_status']?.toString(),
      approvalStatus: json['latest_approval_status']?.toString(),
    );
    return DriverRecordSummary(
      latestEntry: entry,
      logs: const [],
      logCount: _parseInt(json['log_count']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class RecordCard extends StatelessWidget {
  const RecordCard({required this.entry, required this.onTap, super.key});

  final TruckEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final temperatureColor =
        entry.isNormal ? const Color(0xFF17A56B) : const Color(0xFFE5484D);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE7EAF0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.driverName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    '${entry.temperature.toStringAsFixed(1)} F',
                    style: TextStyle(
                      color: temperatureColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: RecordMetaText(value: entry.truckNumber)),
                  const SizedBox(width: 10),
                  RecordMetaText(value: entry.materialType),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    color: Color(0xFF9AA2AF),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      entry.dateTimeLabel,
                      style: const TextStyle(
                        color: Color(0xFF7D8491),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF9AA2AF),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecordMetaText extends StatelessWidget {
  const RecordMetaText({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF515A68),
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class DriverSummaryCard extends StatelessWidget {
  const DriverSummaryCard({
    required this.summary,
    required this.onTap,
    super.key,
  });

  final DriverRecordSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final entry = summary.latestEntry;
    final temperatureColor =
        entry.isNormal ? const Color(0xFF17A56B) : const Color(0xFFE5484D);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE7EAF0)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    entry.driverPhotoPath == null
                        ? Container(
                          height: 48,
                          width: 48,
                          alignment: Alignment.center,
                          color: const Color(0xFFEAF6FC),
                          child: Text(
                            _driverInitials(entry.driverName),
                            style: const TextStyle(
                              color: Color(0xFF1BA7E1),
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        )
                        : DriverPhotoImage(
                          path: entry.driverPhotoPath!,
                          height: 48,
                          width: 48,
                        ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.driverName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${entry.driverPhone}  |  ${summary.totalLogs} log${summary.totalLogs == 1 ? '' : 's'}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF7D8491),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Latest: ${entry.dateTimeLabel}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF9AA2AF),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${entry.temperature.toStringAsFixed(1)} F',
                    style: TextStyle(
                      color: temperatureColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF9AA2AF),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyRecordsState extends StatelessWidget {
  const EmptyRecordsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.search_off_rounded, color: Color(0xFF9AA2AF), size: 48),
          SizedBox(height: 12),
          Text(
            'No matching records',
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Try changing the search or selected filter.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF7D8491), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
