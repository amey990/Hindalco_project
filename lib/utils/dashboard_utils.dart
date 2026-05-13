part of '../main.dart';

InputDecoration _dashboardInputDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Color(0xFF7D8491), fontSize: 13),
    prefixIcon: Icon(icon, color: const Color(0xFF1BA7E1), size: 21),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF1BA7E1), width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE5484D)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE5484D), width: 1.4),
    ),
  );
}

String _formatDateTime(DateTime dateTime) {
  final date = '${_twoDigits(dateTime.day)}/${_twoDigits(dateTime.month)}';
  final year = dateTime.year;
  return '$date/$year, ${_formatTime(dateTime)}';
}

String _formatTime(DateTime dateTime) {
  final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final minute = _twoDigits(dateTime.minute);
  final period = dateTime.hour >= 12 ? 'PM' : 'AM';
  return '${_twoDigits(hour)}:$minute $period';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String _timelineLabel(RecordsTimelineFilter filter) {
  return switch (filter) {
    RecordsTimelineFilter.today => 'Today',
    RecordsTimelineFilter.yesterday => 'Yesterday',
    RecordsTimelineFilter.lastWeek => 'Last week',
    RecordsTimelineFilter.lastMonth => 'Last month',
  };
}

String _driverInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) {
    return 'DR';
  }
  final first = parts.first.characters.first;
  final second = parts.length > 1 ? parts.last.characters.first : '';
  return '$first$second'.toUpperCase();
}

String _normalizeTruckNumber(String value) {
  return value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class DecimalTemperatureFormatter extends TextInputFormatter {
  final RegExp _pattern = RegExp(r'^\d{0,3}(\.\d?)?$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty || _pattern.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
