part of '../main.dart';

class RecordDetailPage extends StatefulWidget {
  const RecordDetailPage({required this.entry, super.key});

  final TruckEntry entry;

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  late TruckEntry _entry = widget.entry;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRecordDetail();
  }

  Future<void> _loadRecordDetail() async {
    final id = widget.entry.id;
    if (id == null || id.isEmpty) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final entry = await RecordService().getRecordById(id);
      if (!mounted) return;
      setState(() {
        _entry = entry;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showAuthMessage(context, _cleanAuthError(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final temperatureColor =
        _entry.isNormal ? const Color(0xFF17A56B) : const Color(0xFFE5484D);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left_rounded),
                    color: const Color(0xFF111827),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: const Size(46, 46),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Record Details',
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              if (_isLoading) ...[
                const LinearProgressIndicator(minHeight: 2),
                const SizedBox(height: 16),
              ],
              if (_entry.driverPhotoPath != null) ...[
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: DriverPhotoImage(
                      path: _entry.driverPhotoPath!,
                      height: 112,
                      width: 112,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE7EAF0)),
                ),
                child: Column(
                  children: [
                    DetailRow(label: 'Driver Name', value: _entry.driverName),
                    DetailRow(label: 'Driver Phone', value: _entry.driverPhone),
                    DetailRow(label: 'Truck Number', value: _entry.truckNumber),
                    DetailRow(
                      label: 'Material Type',
                      value: _entry.materialType,
                    ),
                    DetailRow(
                      label: 'Temperature',
                      value: '${_entry.temperature.toStringAsFixed(1)} F',
                      valueColor: temperatureColor,
                    ),
                    DetailRow(
                      label: 'Temperature Status',
                      value: _entry.isNormal ? 'Normal' : 'High Temperature',
                      valueColor: temperatureColor,
                    ),
                    DetailRow(
                      label: 'Date & Time',
                      value: _entry.dateTimeLabel,
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              if (!_entry.isNormal) ...[
                const SizedBox(height: 16),
                const HighTemperatureBanner(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class DriverRecordsDetailPage extends StatefulWidget {
  const DriverRecordsDetailPage({
    required this.summary,
    this.timeline = 'all',
    super.key,
  });

  final DriverRecordSummary summary;
  final String timeline;

  @override
  State<DriverRecordsDetailPage> createState() =>
      _DriverRecordsDetailPageState();
}

class _DriverRecordsDetailPageState extends State<DriverRecordsDetailPage> {
  DriverRecordsResult? _result;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDriverRecords();
  }

  Future<void> _loadDriverRecords() async {
    setState(() => _isLoading = true);
    try {
      final result = await RecordService().getDriverRecords(
        phone: widget.summary.latestEntry.driverPhone,
        timeline: widget.timeline,
      );
      if (!mounted) return;
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showAuthMessage(context, _cleanAuthError(error));
    }
  }

  Future<void> _downloadDriverReport() async {
    try {
      final path = await ReportService().downloadDriverReport(
        phone: widget.summary.latestEntry.driverPhone,
        timeline: widget.timeline,
      );
      final result = await OpenFilex.open(path);
      if (!mounted) return;
      if (result.type != ResultType.done) {
        _showAuthMessage(context, 'Report saved: $path');
      }
    } catch (error) {
      if (!mounted) return;
      _showAuthMessage(context, _cleanAuthError(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final fallbackDriver = widget.summary.latestEntry;
    final driver = _result?.driver;
    final logs = _result?.records ?? widget.summary.logs;
    final driverName =
        driver?.name.isNotEmpty == true
            ? driver!.name
            : fallbackDriver.driverName;
    final driverPhone =
        driver?.phone.isNotEmpty == true
            ? driver!.phone
            : fallbackDriver.driverPhone;
    final driverPhotoPath =
        driver?.latestPhotoUrl ?? fallbackDriver.driverPhotoPath;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left_rounded),
                    color: const Color(0xFF111827),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: const Size(46, 46),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Driver Records',
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              if (_isLoading) ...[
                const LinearProgressIndicator(minHeight: 2),
                const SizedBox(height: 16),
              ],
              if (driverPhotoPath != null) ...[
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: DriverPhotoImage(
                      path: driverPhotoPath,
                      height: 112,
                      width: 112,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE7EAF0)),
                ),
                child: Column(
                  children: [
                    DetailRow(label: 'Driver Name', value: driverName),
                    DetailRow(
                      label: 'Driver Phone',
                      value: driverPhone,
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'All Time Records (${_result?.total ?? widget.summary.totalLogs})',
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: _downloadDriverReport,
                    icon: const Icon(Icons.download_rounded),
                    tooltip: 'Download driver records',
                    color: const Color(0xFF1BA7E1),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFEAF6FC),
                      fixedSize: const Size(42, 42),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...logs.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: DriverLogCard(entry: entry),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DriverLogCard extends StatelessWidget {
  const DriverLogCard({required this.entry, super.key});

  final TruckEntry entry;

  @override
  Widget build(BuildContext context) {
    final temperatureColor =
        entry.isNormal ? const Color(0xFF17A56B) : const Color(0xFFE5484D);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Column(
        children: [
          DriverLogRow(
            icon: Icons.event_available_outlined,
            label: 'Date & Time',
            value: entry.dateTimeLabel,
          ),
          const SizedBox(height: 10),
          DriverLogRow(
            icon: Icons.thermostat_outlined,
            label: 'Temperature',
            value: '${entry.temperature.toStringAsFixed(1)} F',
            valueColor: temperatureColor,
          ),
          const SizedBox(height: 10),
          DriverLogRow(
            icon: Icons.health_and_safety_outlined,
            label: 'Temperature Status',
            value: entry.isNormal ? 'Normal' : 'High Temperature',
            valueColor: temperatureColor,
          ),
          const SizedBox(height: 10),
          DriverLogRow(
            icon: Icons.local_shipping_outlined,
            label: 'Truck Number',
            value: entry.truckNumber,
          ),
          const SizedBox(height: 10),
          DriverLogRow(
            icon: Icons.inventory_2_outlined,
            label: 'Material Type',
            value: entry.materialType,
          ),
        ],
      ),
    );
  }
}

class DriverLogRow extends StatelessWidget {
  const DriverLogRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = const Color(0xFF111827),
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF1BA7E1), size: 17),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF7D8491),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
