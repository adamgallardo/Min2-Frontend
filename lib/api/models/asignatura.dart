class AsignaturaModel {
  final String id;
  final String name;
  final List<String>? schedule;

  AsignaturaModel({
    required this.id,
    required this.name,
    this.schedule,
  });

  factory AsignaturaModel.fromJson(Map<String, dynamic> json) {
    return AsignaturaModel(
      id: json['_id'],
      name: json['name'],
      schedule:
          json['schedule'] != null ? List<String>.from(json['horari']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'horari': schedule,
    };
  }
}
