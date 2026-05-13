part of '../main.dart';

enum RecordsViewMode { all, byUser }

enum RecordsTimelineFilter { today, yesterday, lastWeek, lastMonth }

class RecordsPage extends StatefulWidget {
  const RecordsPage({
    required this.entries,
    required this.onLogout,
    this.user,
    super.key,
  });

  final List<TruckEntry> entries;
  final VoidCallback onLogout;
  final AppUser? user;

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  final _searchController = TextEditingController();
  RecordsViewMode _selectedMode = RecordsViewMode.all;
  RecordsTimelineFilter _selectedTimeline = RecordsTimelineFilter.today;
  List<TruckEntry> _entries = const [];
  List<DriverRecordSummary> _driverSummaries = const [];
  bool _isLoading = true;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleCount =
        _selectedMode == RecordsViewMode.all
            ? _entries.length
            : _driverSummaries.length;
    final countLabel =
        _selectedMode == RecordsViewMode.all
            ? 'record${visibleCount == 1 ? '' : 's'}'
            : 'driver${visibleCount == 1 ? '' : 's'}';

    return RefreshIndicator(
      onRefresh: _loadRecords,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardHeader(onLogout: widget.onLogout, user: widget.user),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Records',
                          style: TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 118,
                        height: 46,
                        child: DropdownButtonFormField<RecordsTimelineFilter>(
                          value: _selectedTimeline,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                          ),
                          items:
                              RecordsTimelineFilter.values
                                  .map(
                                    (filter) => DropdownMenuItem(
                                      value: filter,
                                      child: Text(_timelineLabel(filter)),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(
                              () =>
                                  _selectedTimeline =
                                      value ?? RecordsTimelineFilter.today,
                            );
                            _loadRecords();
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF1BA7E1),
                                width: 1.4,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        onPressed: _isLoading ? null : _downloadRecordsReport,
                        icon: const Icon(Icons.download_rounded),
                        tooltip: 'Download records',
                        color: const Color(0xFF1BA7E1),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFEAF6FC),
                          fixedSize: const Size(46, 46),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => _onSearchChanged(),
                    textInputAction: TextInputAction.search,
                    decoration: _dashboardInputDecoration(
                      'Search driver or truck number',
                      Icons.search_rounded,
                    ),
                  ),
                  const SizedBox(height: 14),
                  RecordsModeToggle(
                    selectedMode: _selectedMode,
                    onChanged: (mode) {
                      setState(() => _selectedMode = mode);
                      _loadRecords();
                    },
                  ),
                  const SizedBox(height: 18),
                  if (_isLoading) ...[
                    const LinearProgressIndicator(minHeight: 2),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    '$visibleCount $countLabel found',
                    style: const TextStyle(
                      color: Color(0xFF7D8491),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (visibleCount == 0)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyRecordsState(),
            )
          else if (_selectedMode == RecordsViewMode.all)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverList.separated(
                itemCount: _entries.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder:
                    (context, index) => RecordCard(
                      entry: _entries[index],
                      onTap: () => _openRecordDetail(_entries[index]),
                    ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverList.separated(
                itemCount: _driverSummaries.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder:
                    (context, index) => DriverSummaryCard(
                      summary: _driverSummaries[index],
                      onTap:
                          () =>
                              _openDriverRecordsDetail(_driverSummaries[index]),
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _loadRecords() async {
    setState(() => _isLoading = true);
    try {
      if (_selectedMode == RecordsViewMode.all) {
        final records = await RecordService().getRecords(
          timeline: _timelineApiValue(_selectedTimeline),
          search: _searchController.text.trim(),
        );
        if (!mounted) return;
        setState(() {
          _entries = records;
          _driverSummaries = const [];
          _isLoading = false;
        });
      } else {
        final summaries = await RecordService().getRecordsByDriver(
          timeline: _timelineApiValue(_selectedTimeline),
          search: _searchController.text.trim(),
        );
        if (!mounted) return;
        setState(() {
          _entries = const [];
          _driverSummaries = summaries;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _entries = const [];
        _driverSummaries = const [];
        _isLoading = false;
      });
      _showAuthMessage(context, _cleanAuthError(error));
    }
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 450), _loadRecords);
  }

  Future<void> _downloadRecordsReport() async {
    try {
      final path = await ReportService().downloadRecordsReport(
        timeline: _timelineApiValue(_selectedTimeline),
        search: _searchController.text.trim(),
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

  void _openRecordDetail(TruckEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => RecordDetailPage(entry: entry)),
    );
  }

  void _openDriverRecordsDetail(DriverRecordSummary summary) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (_) => DriverRecordsDetailPage(
              summary: summary,
              timeline: _timelineApiValue(_selectedTimeline),
            ),
      ),
    );
  }

  String _timelineApiValue(RecordsTimelineFilter filter) {
    return switch (filter) {
      RecordsTimelineFilter.today => 'today',
      RecordsTimelineFilter.yesterday => 'yesterday',
      RecordsTimelineFilter.lastWeek => 'last_week',
      RecordsTimelineFilter.lastMonth => 'last_month',
    };
  }
}
