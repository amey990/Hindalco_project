class ApiConfig {
  const ApiConfig._();

  static const String baseUrl = 'http://3.110.41.29/api';

  static const String health = '/health';
  static const String dbHealth = '/db-health';
  static const String authMe = '/auth/me';
  static const String materials = '/materials';
  static const String driversSearch = '/drivers/search';
  static const String drivers = '/drivers';
  static const String entries = '/entries';
  static const String entriesRecent = '/entries/recent';
  static const String dashboardStats = '/dashboard/stats';
  static const String dashboardRecentEntries = '/dashboard/recent-entries';
  static const String records = '/records';
  static const String recordsByDriver = '/records/by-driver';
  static const String notifications = '/notifications';
  static const String notificationsReadAll = '/notifications/read-all';
  static const String uploadDriverPhoto = '/uploads/driver-photo';
  static const String reportsRecords = '/reports/records';
  static const String reportsDriver = '/reports/driver';
}
