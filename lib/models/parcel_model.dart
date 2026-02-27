class ParcelModel {
  final String id;
  final String? fileNumber;
  final String commune;
  final String quarter;
  final String address;
  final String? status;
  final int year;
  final String? ownerName;
  final int apartmentCount;
  final String type;
  final double surfaceArea;
  final DateTime createdAt;

  ParcelModel({
    required this.id,
    this.fileNumber,
    required this.commune,
    required this.quarter,
    required this.address,
    this.status,
    required this.year,
    this.ownerName,
    required this.apartmentCount,
    required this.type,
    required this.surfaceArea,
    required this.createdAt,
  });

  factory ParcelModel.fromJson(Map<String, dynamic> json) {
    return ParcelModel(
      id: json['id'] ?? '',
      fileNumber: json['fileNumber'],
      commune: json['commune'] ?? '',
      quarter: json['quarter'] ?? '',
      address: json['address'] ?? '',
      status: json['approvalStatus'],
      year: json['year'] ?? 0,
      ownerName: json['owner']?['fullName'],
      apartmentCount: json['_count']?['apartments'] ?? 0,
      type: json['type'] ?? 'RESIDENTIAL',
      surfaceArea: (json['area'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
