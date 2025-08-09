class DashboardResponse {
  final bool status;
  final String message;
  final DashboardData? data;

  DashboardResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
    DashboardResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'] != null
          ? DashboardData.fromJson(json['data'])
          : null,
    );
}

class DashboardData {
  final int totalUsers;
  final int totalSuperadmin;
  final int totalStaff;
  final int totalParent;
  final int totalCenter;
  final int totalRooms;
  final int totalRecipes;

  DashboardData({
    required this.totalUsers,
    required this.totalSuperadmin,
    required this.totalStaff,
    required this.totalParent,
    required this.totalCenter,
    required this.totalRooms,
    required this.totalRecipes,
  });

  factory DashboardData.fromJson(Map<String, dynamic> j) => DashboardData(
        totalUsers: j['totalUsers'],
        totalSuperadmin: j['totalSuperadmin'],
        totalStaff: j['totalStaff'],
        totalParent: j['totalParent'],
        totalCenter: j['totalCenter'],
        totalRooms: j['totalRooms'],
        totalRecipes: j['totalRecipes'],
      );
}