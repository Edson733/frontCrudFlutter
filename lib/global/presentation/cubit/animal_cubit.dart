import 'package:bloc/bloc.dart'; // Importa el paquete Bloc, que se utiliza para manejar la lógica de negocio y estados en Flutter
import '../../data/models/animal_model.dart'; // Importa el modelo AnimalModel
import '../../data/repository/animal_repository.dart'; // Importa el repositorio AnimalRepository, que maneja las operaciones CRUD
import 'animal_state.dart'; // Importa los diferentes estados posibles del AnimalCubit

class AnimalCubit extends Cubit<AnimalState> {
  final AnimalRepository animalRepository; // Define una variable para el repositorio que manejará las operaciones CRUD

  // Constructor de AnimalCubit, que recibe el repositorio y establece el estado inicial
  AnimalCubit({required this.animalRepository}) : super(AnimalInitial()) {
    fetchAllAnimals(); // Llama al método fetchAllAnimals para cargar todos los animales al iniciar
  }

  // Método asíncrono para obtener todos los animales
  Future<void> fetchAllAnimals() async {
    try {
      emit(AnimalLoading()); // Emite el estado de carga mientras se obtienen los animales
      final animals = await animalRepository.getAllAnimals(); // Obtiene la lista de animales desde el repositorio
      emit(AnimalSuccess(animals)); // Si tiene éxito, emite el estado de éxito con la lista de animales
    } catch (e) {
      emit(AnimalError(e.toString())); // Si hay un error, emite el estado de error con el mensaje de error
    }
  }

  // Método asíncrono para insertar un animal
  Future<void> insertAnimal(AnimalModel animal) async {
    try {
      emit(AnimalLoading()); // Emite el estado de carga mientras se inserta el animal
      await animalRepository.insertAnimal(animal); // Inserta el animal usando el repositorio
      emit(AnimalSuccess(await animalRepository.getAllAnimals())); // Si tiene éxito, emite el estado de éxito con la lista actualizada de animales
    } catch (e) {
      emit(AnimalError(e.toString()));
    }
  }

  // Método asíncrono para actualizar un animal
  Future<void> updateAnimal(AnimalModel animal) async {
    try {
      emit(AnimalLoading()); // Emite el estado de carga mientras se actualiza el animal
      await animalRepository.updateAnimal(animal); // Actualiza el animal usando el repositorio
      emit(AnimalSuccess(await animalRepository.getAllAnimals()));
    } catch (e) {
      emit(AnimalError(e.toString()));
    }
  }

  // Método asíncrono para eliminar un animal
  Future<void> deleteAnimal(int id) async {
    try {
      emit(AnimalLoading()); // Emite el estado de carga mientras se elimina el animal
      await animalRepository.deleteAnimal(id); // Elimina el animal usando el repositorio
      emit(AnimalSuccess(await animalRepository.getAllAnimals()));
    } catch (e) {
      emit(AnimalError(e.toString()));
    }
  }
}