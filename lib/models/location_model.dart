class CommuneModel {
  final String id;
  final String name;

  CommuneModel({required this.id, required this.name});

  factory CommuneModel.fromJson(Map<String, dynamic> json) {
    return CommuneModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class QuarterModel {
  final String id;
  final String name;
  final String? postalCode;

  QuarterModel({required this.id, required this.name, this.postalCode});

  factory QuarterModel.fromJson(Map<String, dynamic> json) {
    return QuarterModel(
      id: json['id'],
      name: json['name'],
      postalCode: json['postalCode'],
    );
  }
}
