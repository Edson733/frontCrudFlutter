import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/animal_model.dart';

class AnimalRepository {
  final String apiUrl;

  AnimalRepository({required this.apiUrl});

  Future<List<AnimalModel>> getAllAnimals() async {
    final response = await http.get(
      Uri.parse('$apiUrl/get'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return List<AnimalModel>.from(list.map((model) => AnimalModel.fromJson(model)));
    } else {
      throw Exception('Ocurrió un error al obtener los animales');
    }
  }

  Future<void> insertAnimal(AnimalModel animal) async {
    final response = await http.post(
      Uri.parse('$apiUrl/post'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(animal.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Ocurrió un error al registrar el animal');
    }
  }

  Future<void> updateAnimal(AnimalModel animal) async {
    final response = await http.put(
      Uri.parse('$apiUrl/put'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(animal.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Ocurrió un error al actualizar el animal');
    }
  }

  Future<void> deleteAnimal(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': id}),
    );
    if (response.statusCode != 200) {
      throw Exception('Ocurrió un error al eliminar el animal');
    }
  }
}