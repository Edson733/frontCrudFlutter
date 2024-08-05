class AnimalModel {
  final int id;
  final String nombre;
  final String raza;
  final int edad;
  final String color;

  // Constructor del objeto
  AnimalModel({ required this.id, required this.nombre, required this.raza, required this.edad, required this.color });

  // Método para convertir un objeto AnimalModel a JSON
  factory AnimalModel.fromJson(List<dynamic> json) {
    return AnimalModel(
      id: json[0] as int,
      nombre: json[1] as String,
      raza: json[2] as String,
      edad: json[3] as int,
      color: json[4] as String,
    );
  }

  // Método para convertir un objeto AnimalModel a un map de datos para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'raza': raza,
      'edad': edad,
      'color': color,
    };
  }
}