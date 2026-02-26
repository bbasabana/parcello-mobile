class UserModel {
  final String id;
  final String name;
  final String? email;
  final String? role;
  final String? commune;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.role,
    this.commune,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      commune: json['commune'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'commune': commune,
    };
  }
}
