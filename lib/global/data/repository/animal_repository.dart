import 'dart:convert'; // Importa el paquete para trabajar con datos JSON
import 'package:http/http.dart' as http; // Importa el paquete http para hacer solicitudes HTTP
import '../models/animal_model.dart'; // Importa el modelo AnimalModel que se utiliza para mapear los datos JSON

class AnimalRepository {
  final String apiUrl; // Define una variable para almacenar la URL base de la API

  AnimalRepository({required this.apiUrl}); // Constructor de la clase que recibe la URL de la API como argumento

  // Método asíncrono para obtener todos los animales desde la API
  Future<List<AnimalModel>> getAllAnimals() async {
    // Realiza una solicitud HTTP GET a la API
    final response = await http.get(
      Uri.parse('$apiUrl/get'), // Construye la URL completa para la solicitud
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', // Define el tipo de contenido como JSON
      }
    );
    if (response.statusCode == 200) { // Verifica si la solicitud fue exitosa (código 200)
      List<dynamic> list = json.decode(response.body); // Decodifica la respuesta JSON en una lista dinámica
      return List<AnimalModel>.from(list.map((model) => AnimalModel.fromJson(model))); // Convierte la lista dinámica en una lista de objetos AnimalModel
    } else {
      throw Exception('Ocurrió un error al obtener los animales'); // Lanza una excepción si la solicitud no fue exitosa
    }
  }

  // Método asíncrono para insertar un nuevo animal en la base de datos a través de la API
  Future<void> insertAnimal(AnimalModel animal) async {
    // Realiza una solicitud HTTP POST a la API
    final response = await http.post(
      Uri.parse('$apiUrl/post'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(animal.toJson()) // Codifica el objeto AnimalModel en JSON y lo envía en el cuerpo de la solicitud
    );
    if (response.statusCode != 200) { // Verifica si la solicitud no fue exitosa (código distinto de 200)
      throw Exception('Ocurrió un error al registrar el animal'); // Lanza una excepción si ocurrió un error al registrar el animal
    }
  }

  // Método asíncrono para actualizar un animal existente en la base de datos a través de la API
  Future<void> updateAnimal(AnimalModel animal) async {
    // Realiza una solicitud HTTP PUT a la API
    final response = await http.put(
      Uri.parse('$apiUrl/put'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(animal.toJson())
    );
    if (response.statusCode != 200) {
      throw Exception('Ocurrió un error al actualizar el animal'); // Lanza una excepción si ocurrió un error al actualizar el animal
    }
  }

  // Método asíncrono para eliminar un animal de la base de datos a través de la API
  Future<void> deleteAnimal(int id) async {
    // Realiza una solicitud HTTP DELETE a la API
    final response = await http.delete(
      Uri.parse('$apiUrl/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': id}) // Codifica el ID del animal en JSON y lo envía en el cuerpo de la solicitud
    );
    if (response.statusCode != 200) {
      throw Exception('Ocurrió un error al eliminar el animal'); // Lanza una excepción si ocurrió un error al eliminar el animal
    }
  }
}