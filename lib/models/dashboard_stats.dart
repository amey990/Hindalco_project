class DashboardStats {
  const DashboardStats({
    required this.totalEntries,
    required this.normalTemperatureCount,
    required this.abnormalTemperatureCount,
    required this.highTemperatureCount,
    required this.trucksInside,
    required this.uniqueDrivers,
    required this.uniqueTrucks,
  });

  final int totalEntries;
  final int normalTemperatureCount;
  final int abnormalTemperatureCount;
  final int highTemperatureCount;
  final int trucksInside;
  final int uniqueDrivers;
  final int uniqueTrucks;

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalEntries: _parseInt(json['total_entries']),
      normalTemperatureCount: _parseInt(json['normal_temperature_count']),
      abnormalTemperatureCount: _parseInt(json['abnormal_temperature_count']),
      highTemperatureCount: _parseInt(json['high_temperature_count']),
      trucksInside: _parseInt(json['trucks_inside']),
      uniqueDrivers: _parseInt(json['unique_drivers']),
      uniqueTrucks: _parseInt(json['unique_trucks']),
    );
  }

  factory DashboardStats.empty() {
    return const DashboardStats(
      totalEntries: 0,
      normalTemperatureCount: 0,
      abnormalTemperatureCount: 0,
      highTemperatureCount: 0,
      trucksInside: 0,
      uniqueDrivers: 0,
      uniqueTrucks: 0,
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
}
