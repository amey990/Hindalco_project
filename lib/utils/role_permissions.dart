import '../models/app_user.dart';

extension RolePermissions on AppUser {
  bool get canCreateEntry => isAdmin || isSupervisor || isSecurity;

  bool get canViewDashboard => isAdmin || isSupervisor || isSecurity;

  bool get canViewRecords => isAdmin || isSupervisor || isSecurity;

  bool get canViewAllRecords => isAdmin || isSupervisor;

  bool get canViewByUserRecords => isAdmin || isSupervisor;

  bool get canAddMaterial => isAdmin || isSupervisor;

  bool get canDownloadReports => isAdmin || isSupervisor;

  bool get canViewNotifications => isAdmin || isSupervisor || isSecurity;

  bool get canAccessAdminPanel => isAdmin;

  bool get canManageUsers => isAdmin;
}
