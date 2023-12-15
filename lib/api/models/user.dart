class UserModel {
  final String id;
  final String name;
  final String password;
  final String email;
  final List<String>? asignaturas;
  final String rol;

  UserModel({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    this.asignaturas,
    required this.rol,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      password: json['password'],
      email: json['email'],
      rol: json['rol'],
      asignaturas: json['asignaturas'] != null
          ? List<String>.from(json['asignaturas'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'email': email,
      'asignaturas': asignaturas,
      'rol': rol,
    };
  }
}
