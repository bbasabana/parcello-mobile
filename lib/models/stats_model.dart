class DashboardStats {
  final int totalParcels;
  final int totalOwners;
  final int totalResidents;
  final List<dynamic> recentParcels;

  DashboardStats({
    required this.totalParcels,
    required this.totalOwners,
    required this.totalResidents,
    required this.recentParcels,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalParcels: json['totalParcels'] ?? 0,
      totalOwners: json['totalOwners'] ?? 0,
      totalResidents: json['totalResidents'] ?? 0,
      recentParcels: json['recentParcels'] ?? [],
    );
  }

  factory DashboardStats.empty() {
    return DashboardStats(
      totalParcels: 0, 
      totalOwners: 0, 
      totalResidents: 0, 
      recentParcels: []
    );
  }
}

